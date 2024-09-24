-- selecting every table to see it imported data correctly

select * from PortfolioProject..df_batting$

select * from PortfolioProject..df_players$

select * from PortfolioProject..df_bowling$

select * from PortfolioProject..df_match$

select matchDate, team1, team2, winner from PortfolioProject..df_match$
order by 1

-- selecting bowler who has taken highest wickets
select bowlerName, max(wickets) as total_wickets, bowlingTeam from PortfolioProject..df_bowling$ 
group by bowlerName, bowlingTeam
order by total_wickets  DESC

-- selecting batsman from team India who secured highest runs
select batsmanName, runs, balls, teamInnings from PortfolioProject..df_batting$
where teamInnings like '%India%'
order by 2 DESC

-- looking at which team and batsman secured highest runs
select batsmanName, runs, balls, teamInnings from PortfolioProject..df_batting$
order by 2 DESC 

--looking at bowler's strike rate - balls per wicket
select bowlerName, (sum(overs)*6)/nullif(sum(wickets),0) as strikerate from PortfolioProject..df_bowling$ 
group by bowlerName

--Total Balls Bowled by a Player
select bowlerName, sum(overs) *6 as total_balls_bowled from PortfolioProject..df_bowling$
group by bowlerName

--looking at which batsman has highest strike rate
select teamInnings, batsmanName, SR from PortfolioProject..df_batting$
order by SR DESC

--finding the maximum victory margin
select match_id, winner, margin from PortfolioProject..df_match$
order by margin DESC

select batsmanName, sum(runs) as Total_runs from PortfolioProject..df_batting$
group by batsmanName
order by Total_runs DESC


-- batsman who has highest 4s and 6s and also who is not_out in match
select batsmanName, max([4s]) as highest_fours, max([6s]) as highest_sixes, [out/not_out] from PortfolioProject..df_batting$
where [out/not_out] = 'not_out'
group by batsmanName, [out/not_out]
order by highest_fours DESC, highest_sixes DESC

--which team has won how many times - ranking each team
select winner, count(winner) from PortfolioProject..df_match$
group by winner
order by count(winner) DESC

--Total 4s and 6s in each match 
select match, sum([4s]) as total_4s, sum([6s]) as total_6s from PortfolioProject..df_batting$
group by match

--total wickets in each match
select match, sum(wickets) as total_wickets from PortfolioProject..df_bowling$
group by match

--number of matches each batsman played
select batsmanName, count(distinct match_id) from PortfolioProject..df_batting$
group by batsmanName

-- joining battings and bowlings table to see who is kinda allrounder
select b.batsmanName, sum(b.runs) as total_runs, sum(bw.wickets) as total_wickets from PortfolioProject..df_batting$ b
left join PortfolioProject..df_bowling$ bw on b.batsmanName = bw.bowlerName
group by b.batsmanName
order by total_runs DESC

--Player who scored centuries
select batsmanName, runs from PortfolioProject..df_batting$
where runs >100

-- ranking each player by overall impact( runs+wickets)
select b.batsmanName, sum(b.runs+ bw.wickets) as overall_impact, RANK() OVER (ORDER BY SUM(b.runs + bw.wickets) DESC) AS player_rank from PortfolioProject..df_batting$ b
left join PortfolioProject..df_bowling$ bw on b.batsmanName = bw.bowlerName
group by b.batsmanName
order by overall_impact DESC

-- creating views
create view rankplayer as select b.batsmanName, sum(b.runs+ bw.wickets) as overall_impact, RANK() OVER (ORDER BY SUM(b.runs + bw.wickets) DESC) AS player_rank from PortfolioProject..df_batting$ b
left join PortfolioProject..df_bowling$ bw on b.batsmanName = bw.bowlerName
group by b.batsmanName
--order by overall_impact DESC

select * from rankplayer