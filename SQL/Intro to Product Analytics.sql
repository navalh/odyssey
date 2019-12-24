#On a typical day, what share of registrants are coming from each acquisition source?

Select reg_attribution, count(*)/avg(total_obs) as share 
From users as a
Cross join 
(select count(*) as total_obs from users) as b
Group by reg_attribution;
/* Note that avg(total_obs) = total_obs, where I could have also used min(total_obs) or max(total_obs). I do this to avoid having to group by total_obs */


#What is the typical lifetime for a user by device? Lifetime defined as time from registration to last activity. 
Create temp table user_lifetimes as
Select a.user_id, reg_device, reg_ts, last_activity
From users as a
Left join 
(select user_id, max(actvy_ts) as last_activity
From activity
Group by user_id) as b
On a.user_id = b.user_id;

Select reg_device, avg(last_activity - reg_ts) as lifetime
From user_lifetimes
Group by reg_device;

/* In Netezza, simply using the subtraction operator between two dates gives the days between two dates. Depending on the SQL variant being used, the – operator may not work the same, or at all. */