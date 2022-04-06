
-- Number each row in the dataset.
select *, row_number() over() from summer_medals

-----------------------------------------------------------------------------------------------
-- Assign a number to each year in which Summer Olympic games were held.
select year, row_number() over() from(
								select distinct year from summer_medals
								order by year
	) as years
	order by year asc

-----------------------------------------------------------------------------------------------
-- Assign a number to each year in which Summer Olympic games were held so that rows with the most recent years have lower row numbers.

SELECT
  Year,
  row_number() OVER (order by year desc) AS Row_N
FROM (
  SELECT DISTINCT Year
  FROM Summer_Medals
) AS Years
ORDER BY Year;

-----------------------------------------------------------------------------------------------
-- For each athlete, count the number of medals he or she has earned.
SELECT
  athlete,
  count(medal) AS Medals
FROM Summer_Medals
GROUP BY Athlete
ORDER BY Medals DESC;

-----------------------------------------------------------------------------------------------
-- Having wrapped the previous query in the Athlete_Medals CTE, rank each athlete by the number of medals they've earned.

WITH Athlete_Medals AS (
  SELECT
    Athlete,
    COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete)

SELECT
  athlete,
  row_number() OVER (ORDER BY Medals DESC) AS Row_N
FROM Athlete_Medals
ORDER BY Medals DESC;

-----------------------------------------------------------------------------------------------
-- Return each year's gold medalists in the Men's 69KG weightlifting competition.
SELECT
  Year,
  Country AS champion
FROM Summer_Medals
WHERE
  Discipline = 'Weightlifting' AND
  Event = '69KG' AND
  Gender = 'Men' AND
  Medal = 'Gold';
  
-----------------------------------------------------------------------------------------------
-- Having wrapped the previous query in the Weightlifting_Gold CTE, get the previous year's champion for each year.

WITH Weightlifting_Gold AS (
  SELECT
    -- Return each year's champions' countries
    Year,
    Country AS champion
  FROM Summer_Medals
  WHERE
    Discipline = 'Weightlifting' AND
    Event = '69KG' AND
    Gender = 'Men' AND
    Medal = 'Gold')

SELECT
  Year, Champion,
  -- Fetch the previous year's champion
  lag(Champion) OVER
    (order by Weightlifting_Gold ASC) AS Last_Champion
FROM Weightlifting_Gold
ORDER BY Year ASC;

-----------------------------------------------------------------------------------------------
-- Return the previous champions of each year's event by gender.

WITH Tennis_Gold AS (
  SELECT DISTINCT
    Gender, Year, Country
  FROM Summer_Medals
  WHERE
    Year >= 2000 AND
    Event = 'Javelin Throw' AND
    Medal = 'Gold')

SELECT
  Gender, Year,
  Country AS Champion,
  -- Fetch the previous year's champion by gender
  LAG(Country) OVER (PARTITION BY Gender
                         ORDER BY Year ASC) AS Last_Champion
FROM Tennis_Gold
ORDER BY Gender ASC, Year ASC;

-----------------------------------------------------------------------------------------------
-- Return the previous champions of each year's events by gender and event.
