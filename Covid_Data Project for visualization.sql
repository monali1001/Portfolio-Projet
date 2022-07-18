use CovidProject;

select * from CovidDeaths$;

select * from Covidvaccinations$;

select location,date,total_cases,new_cases,population
from CovidDeaths$;

--looking for data cases per population
select location,date,total_cases,new_cases,population,(total_cases/population)*100 as CasesPerPopulation
from CovidDeaths$
order by 1,2;

--looking for total cases per death
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathRatio
from CovidDeaths$
order by 1,2;

---looking at the countries having highest infection rates
select location, population, max(total_cases) as highestInfectionCount, max((total_cases/population)*100) as PercentagePopulationInfected
from CovidDeaths$
--where location like '%china%'
Group by Location, population	
order by PercentagePopulationInfected desc

---countries having highest death count 
select location, max(total_deaths) as TotalDeathCount
from CovidDeaths$
--where location like '%china%'
WHERE continent is NOT Null---IF WE WON'T DO IT IT WILL GIVE THE CONTINENT 
Group by Location
order by TotalDeathCount DESC;

---SHOWING CONTINET WITH HIGHEST DEATH COUNT
select continent, max(total_deaths) as TotalDeathCount
from CovidDeaths$
--where location like '%china%'
WHERE continent is NOT Null---IF WE WON'T DO IT IT WILL GIVE THE CONTINENT 
Group by continent
order by TotalDeathCount DESC;

-----Global Numbers
select date,sum(new_cases) as totalcases, sum(cast(new_deaths as int)) as totaldeath, sum(cast(new_deaths as int))/sum(cast(new_cases as int))*100 as deathpercentage
from CovidDeaths$
where continent is not null
group by date
order by 1,2 desc;

--looking at total population vs vaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) 
AS RollingPeopleVaccinated,---,(RollingPeopleVaccinated/population)*100 (here we can't perform this action so for that see below query
from CovidDeaths$ dea
join covidvaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3


---using CTE
with PopVsVac (Continent,location,date,population,new_vaccinations, RollingPeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,sum(cast(vac.new_vaccinations as int)) 
over (partition by dea.location order by dea.location, dea.date) 
AS RollingPeopleVaccinated 
---,(RollingPeopleVaccinated/population)*100
from CovidDeaths$ dea
join covidvaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingPeopleVaccinated/population)*100
from PopVsVac

---TEMP TABLE
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(55),
Location nvarchar(55),
date datetime,
population int,
New_Vaccinations int,
RollingPeopleVaccinated int
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,sum(cast(vac.new_vaccinations as int)) 
over (partition by dea.location order by dea.location, dea.date) 
AS RollingPeopleVaccinated 
---,(RollingPeopleVaccinated/population)*100
from CovidDeaths$ dea
join covidvaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3


select *,(RollingPeopleVaccinated/population)*100 
from #PercentPopulationVaccinated



--CREATING VIEW TO STORE DATA FOR LATER VISUALIZATION
CREATE VIEW PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,sum(cast(vac.new_vaccinations as int)) 
over (partition by dea.location order by dea.location, dea.date) 
AS RollingPeopleVaccinated 
---,(RollingPeopleVaccinated/population)*100
from CovidDeaths$ dea
join covidvaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select * 
from PercentPopulationVaccinated