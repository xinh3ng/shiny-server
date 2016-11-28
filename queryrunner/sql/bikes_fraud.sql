with user_trips as (	
select 
    user_id
    ,count(trip_id) as lifetime_c_trips
    ,sum(CASE WHEN is_paid = 'TRUE' then 1 else 0 end) as lifetime_paid_trips
    ,count(distinct bike_id) as kinds_bikes_used
from trips
    left join bills on bills.bill_id = trips.bill_id
where 1=1
    and is_completed = 'TRUE'
group by 1
),

a as (
select 
    base.*
    ,t.user_id
from (
	  select 
	      bike_id
	      ,max(t.updated_at at time zone 'hkt') as bike_lasttrip_time	
	  from trips t
	  group by 1
	  ) base
join trips t on base.bike_lasttrip_time = t.updated_at at time zone 'hkt'
),

base_bike as (
select 
    b.bike_id
    ,count(t.trip_id) as bike_lt_c_trips
    ,sum(case when bills.is_paid = 'TRUE' then 1 else 0 end) as bike_lt_paid_trips
    ,count(distinct t.user_id) as user_served
from bikes b
join trips t on t.bike_id = b.bike_id
    left join bills on bills.bill_id = t.bill_id
where 1=1
    and is_completed = 'TRUE'
group by 1
)

select 
    b.plate
    ,case when b.plate in (
    	'010002',
		'010007',
		'010016',
		'010023',
		'010025',
		'010039',
		'010041',
		'010049',
		'010053',
		'010054',
		'010080',
		'010086',
		'010087',
		'010090',
		'010093',
		'010094',)
		then 'N' else 'Y' end as is_in_school
    ,bb.bike_lt_c_trips
    ,bb.bike_lt_paid_trips
    ,bb.user_served
    ,date(a.bike_lasttrip_time) as bike_lasttrip_time
    
    ,a.user_id as bike_last_user	
    ,ut.lifetime_c_trips as user_lt_c_trips	
    ,ut.lifetime_paid_trips as user_lt_paid_trips	
    ,ut.kinds_bikes_used
    ,u.name as user_name	
    ,u.cell_phone as user_phone	
    ,u.referrer_cell_phone as referrer	
    ,u.photo_id_value as user_student_id	
    ,u.user_profile->>'city' as user_wechat_city	
    ,u.user_profile->>'nickname' as user_wechat_name	
    ,case when (u.user_profile->>'sex')::numeric = 1 then 'MALE'	
          when (u.user_profile->>'sex')::numeric = 2 then 'FEMALE'	
          when (u.user_profile->>'sex')::numeric = 0 then 'UNKNOWN'	
          end as user_wechat_gender	
from a	
    left join users u on u.user_id = a.user_id	
    left join user_trips ut on ut.user_id = a.user_id	
    left join bikes b on b.bike_id = a.bike_id 
    left join base_bike bb on bb.bike_id = a.bike_id
where 1=1	
    and u.is_active = 'TRUE'	
order by 2 desc,1
