with date as (
	select 
		date('{{start_date}}') as start_date
		,date('{{end_date}}') as end_date
),

base_trips as (
  select 
		date_trunc('day', t.updated_at at time zone 'hkt') as ts
		,count(t.trip_id) as trips
		,sum(case when t.is_completed is TRUE then 1 end ) as completed_trips
		,sum(case when b.is_paid is TRUE then 1 end ) as paid_trips
		,cast(sum(b.total)/100 as decimal (10,2)) as total_fare_CNY
		,cast(sum(case when b.is_paid is TRUE then total end )/100 as decimal (10,2)) as paid_fare_CNY
		,cast((date_part('minute',avg(age(to_timestamp((dropoff->>'timestamp')::bigint/1000) at time zone 'hkt',to_timestamp((pickup->> 'timestamp')::bigint/1000) at time zone 'hkt'))) * 60
		+
		date_part('second',avg(age(to_timestamp((dropoff->>'timestamp')::bigint/1000) at time zone 'hkt',to_timestamp((pickup->> 'timestamp')::bigint/1000) at time zone 'hkt'))))/60 as decimal (10,2))
		as avg_ontrip_minutes
	from trips t
	  left join bills b on b.bill_id = t.bill_id
	cross join date d
	where 1=1 
	  and t.updated_at at time zone 'hkt' >= d.start_date
	  and t.updated_at at time zone 'hkt' <= d.end_date
	group by 1
),

base_users as
	(select 
		date_trunc('day', updated_at at time zone 'hkt') as ts
		,count(*) as signup
	from users
	  cross join date d
	where 1=1 
		and	updated_at at time zone 'hkt' >= d.start_date
		and updated_at at time zone 'hkt' <= d.end_date
	group by 1
),

analysis_users as (
    select 
        b.ts
        , count(b.user_id) as active_users
        , f.ft as first_trip
    from (
	      select 
	          date_trunc('day',nt.updated_at at time zone 'hkt') as ts
	          ,nt.user_id
	          ,count(nt.trip_id) as now_trip
	      from trips nt
	          cross join date d
	      where 1 = 1  
	          and nt.updated_at at time zone 'hkt' >= d.start_date
	          and nt.updated_at at time zone 'hkt' <= d.end_date
	      group by 1,2
	      ) as b
    join (
	      select 
	          min_trip_date
	          ,count(user_id) as ft
	      from (
		        select 
		            user_id
		            ,date_trunc('day',min(t.updated_at at time zone 'hkt')) as min_trip_date
		        from trips t
		    where 1=1
		        and t.is_completed is TRUE
		    group by 1
		    ) a
	      group by 1
	  ) as f on f.min_trip_date = b.ts
  group by 1,3
),

base_bikes as (
    select 
        date_trunc('day',updated_at at time zone 'hkt') as ts,
        count(distinct(bike_id)) as active_bikes
    from trips
        cross join date d
	  where 1=1 
		    and	updated_at at time zone 'hkt' >= d.start_date
	    	and updated_at at time zone 'hkt' <= d.end_date
	    	and is_completed is TRUE
	   group by 1
    )

select 
	bt.*
	,cast(cast(bt.completed_trips as numeric) /cast (bt.trips as numeric) as decimal (10,2)) as c_r
	,cast(cast(bt.paid_trips as numeric) /cast(bt.trips as numeric)as decimal (10,2)) as trips_paid_pct
	,cast(bt.paid_fare_CNY/bt.total_fare_CNY as decimal (10,2)) as fare_paid_pct
	,cast(cast(bt.completed_trips as numeric)/76 as decimal (10,2)) as trips_bike
	,active_bikes as active_bikes
	,cast(bt.total_fare_CNY::numeric / bt.completed_trips::numeric as decimal (10,2)) as avg_fare_trip_cny
	,cast(bt.total_fare_CNY/76 as decimal (10,2)) as avg_fare_bike_cny
	,bu.signup
	,au.first_trip
	,au.active_users
	,cast(cast(bt.completed_trips as numeric) / cast(au.active_users as numeric) as decimal (10,2)) as trips_user
from base_trips bt
join base_users bu on bu.ts = bt.ts
join base_bikes bb on bb.ts = bt.ts
join analysis_users au on au.ts = bt.ts
order by 1 desc
