select
id::text,
bill_id::text,
duration,
rate,
original,
promo,
total,
is_paid,
updated_at at time zone 'hkt' as updated_at,
out_trade_no
from bills
where 1=1
order by updated_at at time zone 'hkt' desc
