with date as (
    select
        date({{start_date}}) as start_date,
        date({{end_date}}) as end_date
),

base_trips as (
    select
        count(t.trip_id) as trips,
        sum(case when t.is_completed is TRUE then 1 end ) as completed_trips,
        sum(case when b.is_paid is TRUE then 1 end ) as paid_trips,
        cast(sum(b.total)/100 as decimal (10,2)) as total_fare_cny,
        cast(sum(case when b.is_paid is TRUE then total end )/100 as decimal (10,2)) as paid_fare_cny,
        cast((date_part('minute', avg(age(to_timestamp((dropoff->>'timestamp')::bigint/1000) at time zone 'hkt',to_timestamp((pickup->> 'timestamp')::bigint/1000) at time zone 'hkt'))) * 60
        +
        date_part('second',avg(age(to_timestamp((dropoff->>'timestamp')::bigint/1000) at time zone 'hkt',to_timestamp((pickup->> 'timestamp')::bigint/1000) at time zone 'hkt'))))/60 as decimal (10,2))
        as avg_ontrip_minutes
    from trips t
    left join bills b on b.bill_id = t.bill_id
    cross join date d
    where 1=1
        and t.updated_at at time zone 'hkt' >= d.start_date
        and t.updated_at at time zone 'hkt' < d.end_date
),

base_users as
    (select
        count(*) as lifetime_signup,
        sum(case when updated_at at time zone 'hkt' >= d.start_date
            and updated_at at time zone 'hkt' < d.end_date
        then 1 end) as signup
    from users
    cross join date d
    where 1=1
),

analysis_users as (
    select
        count(case when now_trips = life_trip then user_id else null end) as first_trips,
        count(b.user_id) as active_users
    from
        (
        select
            nt.user_id,
            count(nt.trip_id) as now_trips,
            lt.life_trip
        from trips nt
        cross join date d
        left join
            (
            select user_id,
                count(trip_id) as life_trip
            from trips
            cross join date d
            where 1=1
            and updated_at at time zone 'hkt' < d.end_date
            group by 1
            ) lt on lt.user_id = nt.user_id
        where 1=1
            and nt.updated_at at time zone 'hkt' >= d.start_date
            and nt.updated_at at time zone 'hkt' < d.end_date
        group by 1,3
            ) as b
)

select
    date(d.start_date) as start_date,
    bt.*,
    cast(cast(bt.completed_trips as numeric) /cast (bt.trips as numeric) as decimal (10,2)) as c_r,
    cast(cast(bt.paid_trips as numeric) /cast(bt.trips as numeric) as decimal (10,2)) as paid_trips_pct,
    cast(bt.paid_fare_cny/bt.total_fare_cny as decimal (10,2)) as paid_fare_pct,
    cast(cast(bt.completed_trips as numeric)/76 as decimal (10,2)) as trips_per_bike,
    cast(bt.total_fare_cny / bt.completed_trips as decimal (10,2)) as total_fare_cny_per_trip,
    cast(bt.total_fare_cny/76 as decimal (10,2)) as total_fare_cny_per_bike,
    bu.signup,
    au.first_trips,
    au.active_users,
    cast(cast(bt.completed_trips as numeric) / cast(au.active_users as numeric) as decimal (10,2)) as trips_per_user
from base_trips bt, base_users bu, analysis_users au, date d
