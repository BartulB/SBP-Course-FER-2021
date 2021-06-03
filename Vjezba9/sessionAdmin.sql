--session Admin

select * from test;

--provjera koja transakcija čeka zbog ključeva koje je postavila neka druga transakcija
SELECT session_id AS sid_blocked
 , blocking_session_id AS sid_blocking
FROM sys.dm_os_waiting_tasks
WHERE blocking_session_id IN (SELECT session_id
							FROM sys.dm_exec_sessions
							WHERE CAST(context_info AS INT) = 7);