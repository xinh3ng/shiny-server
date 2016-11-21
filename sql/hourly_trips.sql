with date as (
    select
        date('{{start_date}}') as start_date,
        date('{{end_date}}') as end_date
),

ts_vec as (
    select generate_series('{{start_date}}'::timestamp, '{{end_date}}'::timestamp, '1 hour') at time zone 'hkt' as ts
),

base_data as (
    select
        date_trunc('hour', updated_at at time zone 'hkt')::timestamp as ts,
        count(trip_id) as completed_trips
    from trips
    cross join date as d
    where 1 = 1
        and updated_at at time zone 'hkt' >= d.start_date
        and updated_at at time zone 'hkt' <= d.end_date
        and is_completed is TRUE
    group by 1
)

select
    ts_vec.ts as ts,
    case when bd.completed_trips is null then 0 else bd.completed_trips end as completed_trips
from
    base_data as bd
    right join ts_vec on ts_vec.ts = bd.ts
order by ts asc

