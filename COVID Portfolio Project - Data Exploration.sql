/*

Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

-----------------------------------------------------------------------------------------------------------------------------------------


Select count(*) from portfolioproject1.covidvaccinations;


SELECT * 
FROM portfolioproject1.cvoiddeaths
Where location='upper middle income'
order by 3,5;

-----------------------------------------------------------------------------------------------------------------------------------------


-- Select the data that were are going to use


Select location, total_cases, new_cases, total_deaths
From portfolioproject1.cvoiddeaths
order by 1, 2;


-----------------------------------------------------------------------------------------------------------------------------------------


-- Calculating the death percentage


Select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From portfolioproject1.cvoiddeaths
order by 1, 2 desc;


-----------------------------------------------------------------------------------------------------------------------------------------


-- Looking at Total cases vs population

-- percentage of people caught infection


Select location, date, total_cases, population, (total_cases/population)*100 as percentage_population_infected
From portfolioproject1.cvoiddeaths
order by 1,2;


-----------------------------------------------------------------------------------------------------------------------------------------


-- Looking at countries with highest infection rate compared to population


Select location, date, max(total_cases),  population, max((total_cases/population))*100 as percentage_population_infected
From portfolioproject1.cvoiddeaths
Group by location
order by percentage_population_infected desc;


-----------------------------------------------------------------------------------------------------------------------------------------


-- Counties with highest death count per population


Select location, max(cast(total_deaths as signed)) as highest_deaths
From portfolioproject1.cvoiddeaths
Where continent is not null
Group by 1
order by highest_deaths desc;


-----------------------------------------------------------------------------------------------------------------------------------------


-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population


Select continent, max(convert(total_deaths, signed)) as highest_deaths
From portfolioproject1.cvoiddeaths
where continent is not null
Group by 1
order by 2 desc;


-----------------------------------------------------------------------------------------------------------------------------------------


-- GLOBAL NUMBERS


SELECT sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, (sum(new_deaths)/sum(new_cases))*100 as death_percentage
FROM portfolioproject1.cvoiddeaths
WHERE continent IS NOT NULL
order by 1,2;


-----------------------------------------------------------------------------------------------------------------------------------------


-- Total Population vs Vaccinations

-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, vac.new_vaccinations, sum(new_vaccinations) 
over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From portfolioproject1.cvoiddeaths as dea
Join portfolioproject1.covidvaccinations as vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
order by 2,3;    


-----------------------------------------------------------------------------------------------------------------------------------------


-- Using CTE to perform Calculation on Partition By in previous query


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as (
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(new_vaccinations) 
	over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	From portfolioproject1.cvoiddeaths as dea
	Join portfolioproject1.covidvaccinations as vac
		on dea.location = vac.location
		and dea.date = vac.date
	where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100 as Percentage_People_Vaccinated
From PopvsVac;


-----------------------------------------------------------------------------------------------------------------------------------------


-- Creating view to store data for later visualizations


Create View PercentPopulationVaccinated2 as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(new_vaccinations) 
	over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	From portfolioproject1.cvoiddeaths as dea
	Join portfolioproject1.covidvaccinations as vac
		on dea.location = vac.location
		and dea.date = vac.date
	where dea.continent is not null;


-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------






