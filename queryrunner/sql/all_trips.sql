select
id::text,
trip_id::text,
user_id::text,
trip_profile::text,
bike_id::text,
trip_tags::text,
pickup::text,
dropoff::text,
is_completed::text,
updated_at::text,
images::text,
bill_id::text
from trips
where 1=1
order by updated_at at time zone 'hkt' desc
