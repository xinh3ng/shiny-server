with user_trips as (	
	select user_id
	,count(trip_id) as lifetime_c_trips
	,sum(CASE WHEN is_paid = 'TRUE' then 1 else 0 end) as lifetime_paid_trips
	,count(distinct bike_id) as bike_used
	from trips
	left join bills on bills.bill_id = trips.bill_id
	where 1=1
	and is_completed = 'TRUE'
	group by 1
)
select u.referrer_cell_phone
,ur.user_id::text as referrer_user_id
,ur.name as referrer_name
,ur.is_active as referrer_account_status
,ut.lifetime_c_trips as referrer_lifetime_c_trips	
,ut.lifetime_paid_trips as referrer_lifetime_paid_trips	
,ut.bike_used
,count(u.user_id) as referrer_lifetime_referral
,ur.photo_id_value as referrer_student_id
,ur.user_profile->>'city' as referrer_wechat_city
,ur.user_profile->>'nickname' as referrer_wechat_name
,case when (ur.user_profile->>'sex')::numeric = 1 then 'male'
when (ur.user_profile->>'sex')::numeric = 2 then 'Female'
when (ur.user_profile->>'sex')::numeric = 0 then 'Unknown'
end as referrer_wechat_gender

from users u
left join users ur on ur.cell_phone = u.referrer_cell_phone
left join user_trips ut on ut.user_id = ur.user_id	
where 1=1
and u.is_active = 'TRUE'
group by 1,2,3,4,5,6,7,9,ur.user_profile
order by 8 desc;
