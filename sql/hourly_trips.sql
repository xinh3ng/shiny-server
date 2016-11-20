with date as (
    select
        date({{start_date}}) as start_date,
        date({{end_date}}) as end_date
)

select
    date_trunc('hour', updated_at at time zone 'hkt')::TIMESTAMP as hour,
    count(trip_id) as completed_trips
from trips
cross join date d
where 1=1
    and updated_at at time zone 'hkt' >= d.start_date
    and updated_at at time zone 'hkt' <= d.end_date
    and is_completed is TRUE
group by 1
order by 1 asc
