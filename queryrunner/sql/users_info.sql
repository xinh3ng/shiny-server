with user_trips as (	
	  select 
		    user_id
		    ,count(trip_id) as lifetime_c_trips
		    ,sum(CASE WHEN is_paid = 'TRUE' then 1 else 0 end) as lifetime_paid_trips
		    ,count(distinct bike_id) as bike_used
	  from trips
		    left join bills on bills.bill_id = trips.bill_id
	  where 1=1
		    and is_completed = 'TRUE'
	  group by 1
)

select 
	  u.user_id::text
	  ,u.updated_at at time zone 'hkt' as signup_time
	  ,ut.lifetime_c_trips as user_lifetime_c_trips	
	  ,ut.lifetime_paid_trips as user_lifetime_paid_trips	
	  ,ut.bike_used
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
from users u	
	  left join user_trips ut on ut.user_id = u.user_id	
where 1=1	
	  and u.is_active = 'TRUE'	
order by 2 desc
