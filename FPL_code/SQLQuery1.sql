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

select






 

