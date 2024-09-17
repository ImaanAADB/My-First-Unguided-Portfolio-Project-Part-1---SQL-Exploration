select *
from PortfolioProject..[COVID_updated_ 2024];

----------------------------------------------------------GENERAL QUERIES------------------------------------------------------------------------d

--Total Deaths from COVID By Country From January 2020 to August 2024
select location, SUM(new_deaths) as total_deaths
from PortfolioProject..[COVID_updated_ 2024]
where continent is not null
group by location
order by total_deaths DESC;

--Total Deaths from COVID By Continent From January 2020 to August 2024
select continent, SUM(new_deaths) as total_deaths
from PortfolioProject..[COVID_updated_ 2024]
where continent is not null
group by continent
order by total_deaths DESC;

--Total Global Deaths By Year
SELECT 
	SUM(new_deaths) AS total_deaths,
	CASE 
		WHEN YEAR(date) = 2020 THEN '2020'
		WHEN YEAR(date) = 2021 THEN '2021'
		WHEN YEAR(date) = 2022 THEN '2022'
		WHEN YEAR(date) = 2023 THEN '2023'
		ELSE '2024'
	END AS year_
FROM PortfolioProject..[COVID_updated_ 2024]
GROUP BY 
    CASE 
        WHEN YEAR(date) = 2020 THEN '2020'
        WHEN YEAR(date) = 2021 THEN '2021'
        WHEN YEAR(date) = 2022 THEN '2022'
        WHEN YEAR(date) = 2023 THEN '2023'
        ELSE '2024'
	END
ORDER By total_deaths DESC
;

--New Cases, New Deaths Trajectory from 2020-2024 by Country (Will be setting up a drop down menu by country)
select location, date, new_cases, new_deaths
from PortfolioProject..[COVID_updated_ 2024]
where continent is not null;


--TOP 10 DEADLIEST DAYS IN THE COVID PANDEMIC FROM JANUARY 2020-AUGUST 2024
Select TOP(10) date, SUM(new_cases) as global_new_cases, SUM(new_deaths) as global_new_deaths  --SUM(new_deaths)/SUM(new_cases)*100 as GlobalDeathPercentage --total_cases, Total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..[COVID_updated_ 2024]
where continent is not null
group by date
order by global_new_deaths DESC;

--global number query (My personal addition) - The Deadiest Day in the Global Pandemic 2021-01-24
Select TOP(10) location, SUM(new_cases) as global_new_cases, SUM(new_deaths) as global_new_deaths
from PortfolioProject..[COVID_updated_ 2024]
where continent is not null AND date LIKE '%2021-01-24%'
group by location
order by global_new_deaths DESC;






----------------------------------------------------------COVID VACCINATION QUERIES------------------------------------------------------------------------d
select *
from PortfolioProject..[Covid_vaccination_testing];

--Relationship between new_tests, new_vaccinations and new_cases on Tableau in the form of a line chart overtime.
With Traj (location, date, new_tests, new_vaccinations, new_cases)
as
(
select a.location, a.date, a.new_tests, a.new_vaccinations, b.new_cases
from PortfolioProject..[Covid_vaccination_testing] a
JOIN PortfolioProject..[COVID_updated_ 2024] b
	ON a.location = b.location AND
	a.date = b.date
--where a.location LIKE '%United States%'
)
select *--,(cast(new_tests as float)/cast(new_cases)*100) as tests_to_cases_percentage
From Traj;

--Attempted to calculate percentage vaccinated but # of vaccinations exceed population. It is possible that total_vaccinations include additional booster shots. On the website, it does indicae that all doses, including boosters are counted individually
--select location, date, population, total_vaccinations, ((CAST(total_vaccinations as float)/population)*100) as percentage_vaccinated
--from PortfolioProject..[Covid_vaccination_testing]
--where continent is not null AND location LIKE '%United States%';