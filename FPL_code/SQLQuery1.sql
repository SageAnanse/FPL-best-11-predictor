--Syntax Dictionary for SSMS
--CTRL+K,CTRL+C= comment
--CTRL+K, CTRL+U=uncomment
--SELECT * 
--INTO sage.dbo.hey 
--FROM dbo.EPL_20_21;

--#start FPL_Code 
  --Aim:To predict first 11 players to choose fro FPL.
  --Columns to make decision are; name, club, nationality, position,age, matches played, starts,
  --mins, goals, assists, passes_attempted,perc_passes_completed,penalty_goals, pena;ty_attempted, expected_goals
  --expected_assists per_game, yellow cards, red cards

  --Firstly we will sift through the teams and see who is likely to start using the the number of games astarted.Starts can be greater than 20 (max 38)
 select *
 into sage.dbo.players_start0
 from sage.dbo.EPL_20_21
 where starts>20
 and Matches>20;

 --select * 
 --from dbo.players_start0;

 select *
 into sage.dbo.players_start1
 from sage.dbo.players_start0
 where Mins>1710;

 --select *
 --from dbo.players_start1;

  select *
 into sage.dbo.players_start
 from sage.dbo.players_start1
 order by Mins DESC;

 --select *
 --from dbo.players_start;

 --Now break the starters down to attackers, mids and defenders

 select*
 into sage.dbo.attackers_start 
 from sage.dbo.players_start
 where Position = 'FW'
 ORDER by Goals DESC;

--Testing hypothesis
 --select*
 --into sage.dbo.attackers_start_hypothesis
 --from sage.dbo.players_start
 --where Position = 'FW'
 --ORDER by Goals DESC,Assists DESC, Passes_Attempted DESC, Perc_Passes_Completed DESC, Penalty_Goals DESC;

 --select *
 --from sage.dbo.attackers_start
 --ORDER by Goals DESC;

 select*
 into sage.dbo.midfielders_start 
 from sage.dbo.players_start
 where Position = 'MF'
 ORDER by Assists DESC;

 --select *
 --from sage.dbo.midfielders_start
 --ORDER by Assists DESC;

  select*
 into sage.dbo.defenders_start 
 from sage.dbo.players_start
 where Position = 'DF'
 ORDER by Goals DESC;

 --Stage 2. Now sift using the goals scored for each team
 --First find average number of goals across attackers, midfielders and defenders
--select
--avg(Goals+Penalty_Goals) as avg_goals 
--into Sage.dbo.add_goals_attack
--from Sage.dbo.attackers_start
--;
----12.92 approx 13 for attackers

--select
--avg(Goals+Penalty_Goals) as avg_goals 
--into Sage.dbo.add_goals_mid
--from Sage.dbo.midfielders_start
--;
----4.2 let's just wrap to 5

--select
--avg(Goals+Penalty_Goals) as avg_goals 
--into Sage.dbo.add_goals_def
--from Sage.dbo.defenders_start
--;
----1.2 wrapped to 2

--For attackers
select * 
into sage.dbo.attackers_goals
from sage.dbo.attackers_start 
where goals+penalty_goals>=13;

--For midfielders
select * 
into sage.dbo.midefielders_goals
from sage.dbo.midfielders_start 
where goals+penalty_goals>=5;

--For defenders
select * 
into sage.dbo.defenders_goals
from sage.dbo.defenders_start 
where goals+penalty_goals>2;

--Passes Completed and Assits (picking from players who are starting becasue some may have more assists than goals)
--Also check average assists use as benchmark

--select
--avg(assists) as avg_assists,
--avg(Perc_Passes_Completed) as av_passes
--into Sage.dbo.add_assists_attack
--from Sage.dbo.attackers_start
--;
----assists = 5.22 approx 5
----av perc_passes = 74.29 approx 74.3

--select
--avg(assists) as avg_assists,
--avg(Perc_Passes_Completed) as av_passes
--into Sage.dbo.add_assists_midfield
--from Sage.dbo.midfielders_start
--;
----assists = 3.12 approx 3
----av perc_passes = 81.829 approx 81.83

--select
--avg(assists) as avg_assists,
--avg(Perc_Passes_Completed) as av_passes
--into Sage.dbo.add_assists_defence
--from Sage.dbo.defenders_start
--;
----assists = 1.4 approx 1.5
----av perc_passes = 81.29


--Now assists from players start and not continue sifting.
select * 
into sage.dbo.attackers_assists
from sage.dbo.attackers_start 
where assists>=5
or Perc_Passes_Completed >=74.3;

select * 
into sage.dbo.midfielders_assists
from sage.dbo.midfielders_start 
where assists>=3
or Perc_Passes_Completed >=81.82;

select * 
into sage.dbo.defenders_assists
from sage.dbo.defenders_start 
where assists>=2
or Perc_Passes_Completed >=81.29;

--Find average of the xA and xG and finally union all and chhose best 11 from each position

select
avg(xA) as avg_xA,
avg(xG) as av_xG
into Sage.dbo.add_exp_attack
from Sage.dbo.attackers_start
;
--xA= 5.22 approx 5
--xG = 74.29 approx 74.3

select
avg(xA) as avg_xA,
avg(xG) as av_xG
into Sage.dbo.add_exp_mid
from Sage.dbo.midfielders_start
;
--xA= 5.22 approx 5
--xG = 74.29 approx 74.3

select
avg(xA) as avg_xA,
avg(xG) as av_xG
into Sage.dbo.add_exp_defen
from Sage.dbo.defenders_start
;
--xA= 5.22 approx 5
--xG = 74.29 approx 74.3



 

