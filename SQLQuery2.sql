/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/
-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From project2..coviddeaths
Where continent is not null 
order by 1,2

-- Total Cases vs Total Deaths- death percentage
-- Shows likelihood of dying if you contract covid in your country

select location,date, (total_deaths/total_cases)*100 as deah_percent
from .coviddeaths
where continent is not null
order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

select location, date,(total_cases/population)*100 as infected_percent
from .coviddeaths
where continent is not null
order by 1,2


-- Countries with Highest Infection Rate compared to Population

select location,  max((total_cases/population)*100) as infected_percent
from .coviddeaths
where continent is not null
group by location
order by infected_percent desc

--PercentPopulationInfected with population and total cases

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  (Max(total_cases)/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

-- Countries with Highest Death Count per Population

select location,  max((total_deaths/population)*100) as death_percent_per_population
from .coviddeaths
where continent is not null
group by location
order by death_percent_per_population desc

-- death count


Select Location, MAX((Total_deaths)) as TotalDeathCount
From .CovidDeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc

--same as

Select Location, ((Total_deaths)) as TotalDeathCount
From .CovidDeaths
Where (continent is not null) and (date ='2021-12-21')

order by TotalDeathCount desc

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count

select location,MAX((Total_deaths)) as TotalDeathCount_per_continent
From .CovidDeaths
Where (continent is null)
Group by location
order by TotalDeathCount_per_continent desc

--BREAKING THINGS DOWN BY income_groups

select location,MAX((Total_deaths)) as TotalDeathCount_per_continent
From .CovidDeaths
Where (continent is null) and (location like '%income')
Group by location
order by TotalDeathCount_per_continent desc


-- BREAKING THINGS DOWN BY CONTINENT

select location,MAX((Total_deaths)) as TotalDeathCount_per_continent
From .CovidDeaths
Where (continent is null) and (location like '%America' or location like 'International' or
location like 'Europe' or location like 'Asia' or location like 'Africa' or location like 'Oceania' or location like 'World' )
Group by location
order by TotalDeathCount_per_continent desc

-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, (SUM(new_deaths)/SUM(New_Cases))*100 as DeathPercentage
From .CovidDeaths
--where continent is not null 
where location like 'World'
order by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine



--percentage vaccinated in the world

with vaccine as(
select location, date,sum(new_vaccinations) over(partition by location order by location, date) as running_total_vaccinations 
from covidvaccination
where continent is not null
)
select v.location, v.date,v.running_total_vaccinations ,d.population,(v.running_total_vaccinations/d.population)*100 as percent_vaccinated from vaccine v
join coviddeaths d
on v.location = d.location and v.date=d.date
--where d.location like 'India'
order by 1,2

/*--creating a view

Create View PercentPopulationVaccinated as

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null */

--creating a view

create view total_vaccinated_per_population as
with vaccine as(
select location, date,sum(new_vaccinations) over(partition by location order by location, date) as running_total_vaccinations 
from covidvaccination
where continent is not null
)
select v.location, v.date,v.running_total_vaccinations ,d.population,(v.running_total_vaccinations/d.population)*100 as percent_vaccinated from vaccine v
join coviddeaths d
on v.location = d.location and v.date=d.date
--where d.location like 'India'
--order by 1,2
select * from total_vaccinated_per_population