--Select *
--From CovidDeaths$
--order by 3, 4;

--Select *
--From CovidVaccination$
--order by 3,4;

Select location,date,total_cases,new_cases,total_deaths,population
From CovidDeaths$
Order by 1,2;

--Total  cases vs total deaths

Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
From CovidDeaths$
Where location like 'india'
Order by 1,2; 


--Total cases vs Population
Select location,date,population,total_cases,(total_cases/population)*100 as Casespercentage
From CovidDeaths$
Where location like 'india'
Order by 1,2; 

--countries with Highest infection rate wrt population
Select location,population,Max(total_cases) as HighestInfectionCount,Max(total_cases/population)*100 as PercentagePopultaionInfected
From CovidDeaths$
where continent is NOT NULL
Group by location, population
Order by PercentagePopultaionInfected desc; 

--Showing countries with highest deathcount per population

Select location,Max(cast(total_deaths as int)) as TotalDeaths
From CovidDeaths$
where continent is  NULL
Group by location 
Order by TotalDeaths desc; 


--BY CONTINENT
--Continent with highest death count  
Select continent,Max(cast(total_deaths as int)) as TotalDeaths
From CovidDeaths$
where continent is not NULL
Group by continent 
Order by TotalDeaths desc; 



--Continent with highest cases
Select continent,Max(cast(total_cases as int)) as TotalCases
From CovidDeaths$
where continent is not NULL
Group by continent 
Order by TotalCases desc; 

--Global data

Select Sum(new_cases) as TotalCases,Sum(cast(new_deaths as int)) as TotalDeaths,(Sum(cast(new_deaths as int ))
/Sum(new_cases))*100  as  Deathpercentage 
From CovidDeaths$
Where continent is not null
--group by date
Order by 1,2; 

--VACCINATION TABLE


Select * 
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccination$ vac
on dea.location= vac.location
and dea.date=vac.date

--Total population vs Vaccination
Select dea.continent,dea.location,dea.date,dea.population ,vac.new_vaccinations
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccination$ vac
on dea.location= vac.location
and dea.date=vac.date 
where dea.continent is not null
order by 2,3

Select dea.continent,dea.location,dea.date,dea.population ,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int )) Over ( Partition by dea.location order by dea.location,dea.date) as RollingpeopleVaccination
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccination$ vac
on dea.location= vac.location
and dea.date=vac.date 
where dea.continent is not null
order by 2,3


--USE CTE

 With PopVsVac(continent,location,date,popultaion,new_vaccination,RollingpeopleVaccination)
 as
(
Select dea.continent,dea.location,dea.date,dea.population ,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int )) Over ( Partition by dea.location order by dea.location,dea.date) as RollingpeopleVaccination
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccination$ vac
on dea.location= vac.location
and dea.date=vac.date 
where dea.continent is not null
)
Select *, (RollingpeopleVaccination/popultaion)*100
from PopVsVac


--With temp table
Drop Table if exists #PercentagePopultaionVacciated
Create table #PercentagePopultaionVacciated
(
Continent  nvarchar(255),
Location nvarchar(255),
Date datetime,
Popultation numeric,
New_vaccination numeric,
RollingpeopleVaccination numeric
)
Insert into #PercentagePopultaionVacciated
Select dea.continent,dea.location,dea.date,dea.population ,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int )) Over ( Partition by dea.location order by dea.location,dea.date) as RollingpeopleVaccination
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccination$ vac
on dea.location= vac.location
and dea.date=vac.date 
where dea.continent is not null

Select *, (RollingpeopleVaccination/Popultation)*100
from  #PercentagePopultaionVacciated


--Creating View  for later Visualization
Create View  PercentagePopultaionVaccine as 
Select dea.continent,dea.location,dea.date,dea.population ,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int )) Over ( Partition by dea.location order by dea.location,dea.date) as RollingpeopleVaccination
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccination$ vac
on dea.location= vac.location
and dea.date=vac.date 
where dea.continent is not null
 

 Select *
 From PercentagePopultaionVaccine;