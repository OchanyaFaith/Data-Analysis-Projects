select * from PortfolioProject..CovidDeaths
order by 3,4

select * from PortfolioProject..CovidVaccinations
order by 3,4

select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--looking at total cases vs total deaths

select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from PortfolioProject..CovidDeaths
where location like '%nigeria%'
order by 1,2 

--looking at the total cases vs population
--shows what percentage of population got covid
select Location, date, population, total_cases,  (total_cases/population)*100 as total_cases_percentage
from PortfolioProject..CovidDeaths
where location like '%nigeria%'
order by 1,2 

--showing at countries with highest infection rate compared to the population
select Location, population, MAX(total_cases) as HigestinfectionCount,  MAX((total_cases/population))*100 as infectedPercentPop
from PortfolioProject..CovidDeaths
where continent is not null
group by location, population
order by infectedPercentPop desc

--showing countries with highest death count per population
select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by Location
order by TotalDeathCount desc

--breaking data dowwn by continent
select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

--Global numbers analysis
--showing total cases vs total total deaths for the whole world by date
select date, SUM(new_cases) as total_cases,
SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 
as deathpercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2 


--looking at total population vs vaccinations
--USE CTE
with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccination)
as
(
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
sum(convert(int,cv.new_vaccinations)) over (Partition by cd.location order by cd.location,cd.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccinations cv
    on  cd.date = cv.date
	and cd.location = cv.location 
	where cd.continent is not null
	)

	select * , (RollingPeopleVaccination/population)*100 as RPP_percentage
	from PopvsVac

--USE TEMP TABLE
drop table if exists PeopleVaccinatedPercentage
create table PeopleVaccinatedPercentage
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population nvarchar(255),
New_vacc numeric,
RollingPpleVacc numeric
)

insert into PeopleVaccinatedPercentage
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
sum(convert(int,cv.new_vaccinations)) over (Partition by cd.location order by cd.location,cd.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccinations cv
    on  cd.date = cv.date
	and cd.location = cv.location 
	where cd.continent is not null

	
select *, (RollingPpleVacc/population)*100
from PeopleVaccinatedPercentage

--creating view to store data for visulisation
--drop view if exists PeopleVaccinated
create view PeopleVaccinated as
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
sum(convert(int,cv.new_vaccinations)) over (Partition by cd.location order by cd.location,cd.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccinations cv
    on  cd.date = cv.date
	and cd.location = cv.location 
where cd.continent is not null
