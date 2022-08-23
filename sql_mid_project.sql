
-- 1. Create a database called `house_price_regression`.

create database house_price_regression;
use house_price_regression;

-- 2. Create a table `house_price_data` with the same columns as given in the csv file. Please make sure you use the correct data types for the columns. You can find the names of the headers for the table in the `regression_data.xls` file. Use the same column names as the names in the excel file. Please make sure you use the correct data types for each of the columns.
drop table if exists house_price_data;
CREATE TABLE house_price_data (
  `id` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `bedrooms` int(4) DEFAULT NULL,
  `bathrooms` float DEFAULT NULL,
  `sqft_living` float DEFAULT NULL,
  `sqft_lot` float DEFAULT NULL,
  `floors` int(4) DEFAULT NULL,
  `waterfront` int(4) DEFAULT NULL,
  `view` int(4) DEFAULT NULL,
  `condition` int(4) DEFAULT NULL,
  `grade` int(4) DEFAULT NULL,
  `sqft_above` float DEFAULT NULL,
  `sqft_basement` float DEFAULT NULL,
  `yr_built` int(11) DEFAULT NULL,
  `yr_renovated` int(11) DEFAULT NULL,
  `zip_code` int(11) DEFAULT NULL,
  `lat` float DEFAULT NULL,
  `lon` float DEFAULT NULL,
  `sqft_living15` float DEFAULT NULL,
  `sqft_lot15` float DEFAULT NULL,
  `price` float DEFAULT NULL,
  PRIMARY KEY (`id`)
);

# ATENTION: it is easier to use the Data Import Wizard instead of step 3.
-- 3. Import the data from a csv file into the table (save the excel file as csv). Before you import the data into the empty table, make sure that you have deleted the headers from the csv file. (in this case we have already deleted the header names from the csv files).  To not modify the original data, if you want you can create a copy of the csv file as well. Note you might have to use the following queries to give permission to SQL to import data from csv files in bulk:
SET GLOBAL local_infile=1;
Query OK, 0 rows affected (0.00 sec)

load data local infile 'C:\Users\parag\Desktop\ironhack\units\unit 5\regression\regression_data.xls'
into table house_price_data
fields terminated by ',';

-- 4.  Select all the data from table `house_price_data` to check if the data was imported correctly

select * from regression_data;
-- 5.  Use the alter table command to drop the column `date` from the database, as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.
alter table regression_data
drop column date;
select * from regression_data
limit 10;
-- 6.  Use sql query to find how many rows of data you have.
select count(*) from regression_data;
-- 7.  Now we will try to find the unique values in some of the categorical columns:

    -- What are the unique values in the column `bedrooms`?
    -- What are the unique values in the column `bathrooms`?
    -- What are the unique values in the column `floors`?
    -- What are the unique values in the column `condition`?
    -- What are the unique values in the column `grade`?

select distinct bedrooms from regression_data;
select distinct bathrooms from regression_data;
select distinct floors from regression_data;
select distinct `condition` from regression_data;
select distinct grade from regression_data;

-- 8.  Arrange the data in a decreasing order by the price of the house. Return only the IDs of the top 10 most expensive houses in your data.
select ï»¿id as id from regression_data
order by price desc
limit 10;

-- 9.  What is the average price of all the properties in your data?
select round(avg(price),2) from regression_data;

-- 10. In this exercise we will use simple group by to check the properties of some of the categorical variables in our data

    -- What is the average price of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the prices. Use an alias to change the name of the second column.
    -- What is the average `sqft_living` of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the `sqft_living`. Use an alias to change the name of the second column.
    -- What is the average price of the houses with a waterfront and without a waterfront? The returned result should have only two columns, waterfront and `Average` of the prices. Use an alias to change the name of the second column.
    -- Is there any correlation between the columns `condition` and `grade`? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
        -- You might also have to check the number of houses in each category (ie number of houses for a given `condition`) to assess if that category is well represented in the dataset to include it in your analysis. For eg. If the category is under-represented as compared to other categories, ignore that category in this analysis


select bedrooms, round(avg(price),2) as "Average Price" from regression_data
group by bedrooms;

select bedrooms, round(avg(sqft_living),2) as "Average Sqft Living" from regression_data
group by bedrooms;

select waterfront, round(avg(price),2) as 'Average Price' 
from regression_data
group by waterfront;

select `condition`, avg(grade) as Average_Grade, count(*) as Number_of_Houses
from regression_data
group by `condition`
order by `condition`;

-- 11. One of the customers is only interested in the following houses:

    -- Number of bedrooms either 3 or 4
    -- Bathrooms more than 3
    -- One Floor
    -- No waterfront
    -- Condition should be 3 at least
    -- Grade should be 5 at least
    -- Price less than 300000
    -- For the rest of the things, they are not too concerned. Write a simple query to find what are the options available for them?

select * from regression_data
where bedrooms in (3, 4) and bathrooms > 3 
and floors = 1 and waterfront = 0
and `condition` >= 3 and grade >= 5 and price < 300000;

-- 12. Your manager wants to find out the list of properties whose prices are twice more than the average of all the properties in the database. Write a query to show them the list of such properties. You might need to use a sub query for this problem.
select * from regression_data
where price > (select avg(price)*2 from regression_data);

-- 13. Since this is something that the senior management is regularly interested in, create a view called `Houses_with_higher_than_double_average_price` of the same query.
create view Houses_with_higher_than_double_average_price as 
select * from regression_data
where price > (select avg(price)*2 from regression_data);

-- 14. Most customers are interested in properties with three or four bedrooms. What is the difference in average prices of the properties with three and four bedrooms? In this case you can simply use a group by to check the prices for those particular houses
select bedrooms, round(avg(price),2)
 from regression_data
where bedrooms in (3,4)
group by bedrooms; 

-- 15. What are the different locations where properties are available in your database? (distinct zip codes)
select distinct `zipcode` from regression_data;

-- 16. Show the list of all the properties that were renovated.
select * from regression_data
where yr_renovated = 0;

-- 17. Provide the details of the property that is the 11th most expensive property in your database.
select * from regression_data 
order by price desc 
limit 10,1;