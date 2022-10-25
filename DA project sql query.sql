
--data analysis sql data exploration project

SELECT *
FROM DA_Project..CovidDeaths
WHERE continent IS NOT null 
order by 3,4
--creating separate table for vac

CREATE TABLE CovidVaccinations 
(iso_code nvarchar(255),
continent nvarchar(255),
location nvarchar(255),
date datetime)



--inserting data from coviddeaths to vacc

INSERT INTO CovidVaccinations 
SELECT iso_code,continent,location,date
FROM DA_Project..CovidDeaths

--select data that we are going to use
SELECT location, date,total_cases,new_cases,total_deaths,population
FROM DA_Project..CovidDeaths
ORDER BY 1,2


--looking at total_cases vs total_deaths
SELECT location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS percentage_of_death
FROM DA_Project..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1,2

--total_cases vs population
SELECT location, date,total_cases,population,(total_cases/population)*100 AS infected_ppl_percentage
FROM DA_Project..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1,2


--looking at countries with highest infection rate as compared to population
SELECT location,population, MAX(total_cases) AS highest_infection_count, MAX(total_cases/population)*100 AS infected_ppl_percentage
FROM DA_Project..CovidDeaths
group by location, population
ORDER BY 4 DESC

--how many people died
SELECT location,MAX(CAST( total_deaths as int) )AS total_deaths
FROM DA_Project..CovidDeaths
WHERE continent is not null
group by location 
ORDER BY 2 DESC


--LET's break things by continent
SELECT continent,MAX(CAST( total_deaths as int) )AS total_deaths
FROM DA_Project..CovidDeaths
WHERE continent is not null
group by continent
ORDER BY 2 DESC

-- this data is quite incorrectr bcs it is missing a lot of data so we'll improve this

SELECT location,MAX(CAST( total_deaths as int) )AS total_deaths
FROM DA_Project..CovidDeaths
WHERE continent is  null
group by location
ORDER BY 2 DESC

--global numbers
SELECT date,sum(new_cases) AS Total_cases , sum(cast(new_deaths as int)) as total_deaths, sum(cast( new_deaths as int))/sum(New_cases)*100 AS death_percent

FROM DA_Project..CovidDeaths
where continent is not null
group by date
order by 1,2

--joining tables and aliasing
--population vs vaccinantion
select *
from DA_Project..CovidDeaths as dea
join DA_Project..CovidVaccinations as vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2

-- use of partition by
select location,date, population,
COUNT(total_deaths) over (partition by date) AS datewise_deaths

from CovidDeaths

--creating a temp table 
CREATE TABLE  #temp_vac
(continent nvarchar(255),
location nvarchar(255),
date datetime,
population float,
total_cases float,
total_deaths nvarchar(255)
)

INSERT INTO #temp_vac
SELECT continent,location,date,population,total_cases,total_deaths
FROM DA_Project..CovidDeaths

select*
from #temp_vac


--creating a view to store data for later visualizations
create view datewise_deaths as
select location,date, population,
COUNT(total_deaths) over (partition by date) AS datewise_deaths

from CovidDeaths




