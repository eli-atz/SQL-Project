-- TABLES CREATION

CREATE TABLE IF NOT EXISTS country_data (
    Country VARCHAR(255),
    Abbreviation VARCHAR(2),
    Land_Area_Km2 INTEGER,
    Armed_Forces_Size INTEGER,
    Capital_Major_City VARCHAR(255),
    Currency_Code VARCHAR(5),
    GDP INTEGER,
    Largest_City VARCHAR(255),
    Official_Language VARCHAR(255),
    Population INTEGER
);


CREATE TABLE demographic_data (
    Country VARCHAR(255),
    Density_Per_Km2 FLOAT,
    Birth_Rate FLOAT,
    Fertility_Rate FLOAT,
    Gross_Primary_Education_Enrollment FLOAT,
    Gross_Tertiary_Education_Enrollment FLOAT,
    Life_Expectancy FLOAT,
    Minimum_Wage FLOAT,
    Population INTEGER,
    Population_Labor_Force_Participation FLOAT,
    Unemployment_Rate FLOAT,
    Urban_Population INTEGER
);


CREATE TABLE IF NOT EXISTS economic_data (
    Country VARCHAR(255),
    Abbreviation VARCHAR(2),
    Agricultural_Land_Percentage FLOAT,
    Co2_Emissions INTEGER,
    Currency_Code VARCHAR(5),
    Forested_Area_Percentage FLOAT,
	Gdp BIGINT,
    Gasoline_Price_Dollars FLOAT,
	Minimum_Wage FLOAT,
    Population INTEGER,
    Population_Labor_Force_Participation_Percentage FLOAT,
    Tax_Revenue_Percentage FLOAT,
    Total_Tax_Rate FLOAT,
    Unemployment_Rate FLOAT
);
                       

CREATE TABLE energy_data (
    entity VARCHAR(255),
    year INTEGER,
    electricity_from_fossil_fuels_TWh FLOAT,
    electricity_from_nuclear_TWh FLOAT,
    electricity_from_renewables_TWh FLOAT,
    renewables_percent_equivalent_primary_energy FLOAT 
);




-- DATA CLEANING

-- Rename some columns to simplify future queries

ALTER TABLE demographic_data
RENAME COLUMN population_labor_force_participation TO population_labor_force_perc;

ALTER TABLE demographic_data
RENAME COLUMN gross_primary_education_enrollment TO primary_education_enroll;

ALTER TABLE demographic_data
RENAME COLUMN gross_tertiary_education_enrollment TO tertiary_education_enroll;

ALTER TABLE economic_data
RENAME COLUMN population_labor_force_participation_percentage TO population_labor_force_perc;

ALTER TABLE energy_data
RENAME COLUMN renewables_percent_equivalent_primary_energy TO renewables_percent;


-- DATA ANALYSIS
 
-- The result set will include the top 10 countries with the highest CO2 emissions. 
SELECT country, co2_emissions
FROM economic_data
WHERE co2_emissions IS NOT NULL
ORDER BY co2_emissions DESC
LIMIT 10;

-- The result set will include information about China's electricity generation
-- from fossil fuels, nuclear, and renewables, for each year.
SELECT
	entity,
	year,
	electricity_from_fossil_fuels_twh,
	electricity_from_nuclear_twh,
	electricity_from_renewables_twh
FROM energy_data
WHERE entity = 'China'
ORDER BY year ASC;


-- The result set will include information about United States' electricity generation
-- from fossil fuels, nuclear, and renewables, for each year.
SELECT 
    entity, 
    year, 
    electricity_from_fossil_fuels_twh, 
    electricity_from_nuclear_twh, 
    electricity_from_renewables_twh
FROM energy_data
WHERE entity = 'United States'
ORDER BY year ASC;

-- JOIN 1
-- Compare various variables from different tables
-- (country, land_area_km2, density_per_km2, population, urban_population_percentage)
-- for countries with the highest population.

SELECT c.country, c.land_area_km2, d.density_per_km2, d.population, d.urban_population_percentage
FROM country_data c
JOIN demographic_data d ON c.country = d.country
WHERE d.population IS NOT NULL AND d.urban_population_percentage IS NOT NULL
ORDER BY d.population DESC
LIMIT 10;

-- The result set will include the top 10 countries with the highest gdp.
SELECT country, gdp
FROM economic_data
WHERE gdp IS NOT NULL
ORDER BY gdp DESC
LIMIT 10;


-- The result set will include the top 10 countries with the lowest CO2 emissions.
SELECT country, co2_emissions
FROM economic_data
WHERE co2_emissions IS NOT NULL
ORDER BY co2_emissions ASC
LIMIT 10;

--JOIN 2	
-- Compare various variables from different tables
-- (country, land_area_km2, density_per_km2, population, forested_area_percentage)
-- for countries with the lowest population.
SELECT c.country, c.land_area_km2, d.density_per_km2, d.population, e.forested_area_percentage
FROM country_data c
JOIN demographic_data d ON c.country = d.country
JOIN economic_data e ON d.population = e.population
WHERE d.population IS NOT NULL 
ORDER BY d.population ASC
LIMIT 20;


-- The result set will include the top 10 countries with the highest percentage of renewable energy usage.
SELECT 
    entity, 
    year, 
    renewables_percent
FROM energy_data
WHERE 
    year = 2020
	AND renewables_percent IS NOT NULL
ORDER BY renewables_percent DESC
LIMIT 10;


-- The result set will include information about Iceland's electricity generation
-- from fossil fuels, nuclear, and renewables, for each year.
SELECT 
    entity, 
    year, 
    electricity_from_fossil_fuels_twh, 
    electricity_from_nuclear_twh, 
    electricity_from_renewables_twh
FROM energy_data
WHERE entity = 'Iceland'
ORDER BY year ASC;



-- Extraction of the average percentage of global renewable energy for the period 2000-2020
SELECT
    year,
    AVG(renewables_percent) AS average_renewables_percent
FROM
    energy_data
WHERE
    year BETWEEN 2000 AND 2020
GROUP BY
    year
ORDER BY
    year;
	




