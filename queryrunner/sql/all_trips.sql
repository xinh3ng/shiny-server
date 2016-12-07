select
    t.id::text,
    t.trip_id::text,
    t.user_id::text,
   
    u.name as user_name,
	  u.cell_phone as user_phone,
	  u.user_profile->>'nickname' as user_wechat_name,
	  
    t.trip_profile::text,
    t.bike_id::text,
    t.trip_tags,
    to_timestamp((t.pickup->>'timestamp')::bigint/1000) at time zone 'hkt' as pikcup_ts,
    to_timestamp((t.dropoff->>'timestamp')::bigint/1000) at time zone 'hkt' as dropoff_ts,
    cast((
        date_part('minute',
            age(
                to_timestamp((t.dropoff->>'timestamp')::bigint/1000) at time zone 'hkt',
                to_timestamp((t.pickup->> 'timestamp')::bigint/1000) at time zone 'hkt'
            )
        )* 60
    	  +
    		date_part('second',
    		    age(
    		        to_timestamp((t.dropoff->>'timestamp')::bigint/1000) at time zone 'hkt',
    		        to_timestamp((t.pickup->> 'timestamp')::bigint/1000) at time zone 'hkt'
    		    )
    		))/ 60 
    as decimal (10,2)) as duration_minutes,
    t.is_completed,
    t.updated_at,
    t.images::text,
    t.bill_id::text
from trips t
    left join users u on u.user_id = t.user_id
where 1=1
order by t.updated_at at time zone 'hkt' desc
