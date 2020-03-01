#Using limit statements
select points_used
from item_points
where points_used is not NULL
and date = '2017-01-02'
order by points_used desc
limit 1;


#Using row_number()
select name, email
from (
    select name, email, row_number() over (partition by name order by email) as duplicate_number
    from users
)
where duplicate_number <> 1;

select name, email
from (
    select name, email, row_number() over (partition by name, email order by email) as duplicate_number
    from users
)
where duplicate_number <> 1;

#Using Common Table Expressions (CTEs)
with installs as (
    select device_id, 
           timestamp 
    from installs
),
uninstalls as (
    select device_id, 
           timestamp 
    from uninstalls
),
device_history as (
    select installs.device_id, 
           installs.timestamp, 
           uninstalls.timestamp,
           timestamp_diff(uninstalls.timestamp, installs.timestamp, day) as days_diff,
           row_number() over (partition by installs.device_id, installs.timestamp order by days_diff) as correct_install_uninstall_pair
    from installs 
    left join uninstalls using (device_id)
    where days_diff >= 0
 )

select timestamp_trunc(installs.timestamp, hour) as hour,
       count(case when timestamp_diff(uninstalls.timestamp, installs.timestamp, hour) <= 1 then uninstalls.device_id else null end)/COUNT(installs.device_id) as one_hr_bounce_rate
from device_history
where correct_install_uninstall_pair = 1
group by hour;
