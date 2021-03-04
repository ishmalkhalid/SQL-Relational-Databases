-----------------------------------------------------------------------------
-- 1. In an SQL comment below, describe the relationship (one-to-one,
--    many-to-one, or many-to-many) between the pairs of tables listed
--    (note that you may need to look at a third table to determine the
--    relationship).
--
--    Additionally, add the queries you used to arrive at your answers.
--
--    a. countries and country_stats
--    b. languages and countries
--    c. continents and regions
-----------------------------------------------------------------------------
-- a. many-to-one relationship 
show create table countries; -- one side
show create table country_stats; -- many side

-- b. many-to-many relationship 
show tables;
show create table country_languages; -- contains references to both the tables
show create table countries;
show create table languages;

-- c. many-to-one relationship 
show create table continents; -- one
show create table regions; -- many


-----------------------------------------------------------------------------
-- 2. Create a report displaying every name and population of every
--    continent in the database from the year 2018 with millions as units
--
--    For example:
--
-- Asia           4376.9086
-- Africa         1259.7617
-- Europe          717.2167
-- North America   569.6298
-- South America   394.5288
-- Oceania          40.9416
--
--     Write your query below.
-----------------------------------------------------------------------------
select c.name, sum(cs.population)/1000000 as population from country_stats cs inner join countries on countries.country_id = cs.country_id  inner join regions r on countries.region_id = r.region_id inner join continents c on c.continent_id = r.continent_id where cs.year = 2018 group by c.continent_id order by population desc;

-----------------------------------------------------------------------------
-- 3. List the names of all of the countries that do not have a language.
--    Write your answer in an SQL comment below along with the original
--    query that you used to arrive at your answer.
-----------------------------------------------------------------------------
-- +----------------------------------------------+
-- | name                                         |
-- +----------------------------------------------+
-- | Antarctica                                   |
-- | French Southern territories                  |
-- | Bouvet Island                                |
-- | Heard Island and McDonald Islands            |
-- | British Indian Ocean Territory               |
-- | South Georgia and the South Sandwich Islands |
-- +----------------------------------------------+

select c.name from countries c left outer join country_languages cl on cl.country_id = c.country_id left outer join languages l on l.language_id = cl.language_id where l.language is NULL;

-----------------------------------------------------------------------------
-- 4. Show the country name and total number of languages of the top 10
--    countries with the most languages in descending order (according to the
--    data in this data set). Write your query below.
-----------------------------------------------------------------------------
select c.name, count(cl.country_id) as total_languages from countries c  inner join country_languages cl on c.country_id = cl.country_id group by c.name order by total_languages desc limit 10;

-----------------------------------------------------------------------------
-- 5. Repeat your previous query, but with a comma separated list of 
--    languages rather than a count. For example:
--
--     name   | languages
--     -------+---------------------------------
--     Canada |  "Dutch,English,Spanish,French,Portuguese,Italian,German,Polish,Ukrainian,Chinese,Eskimo Languages,Punjabi"
--
--    Hint: use the aggregate function, group_concat to do this
--
--    Write your code below
-----------------------------------------------------------------------------
 select c.name, group_concat(l.language)  from countries c inner join country_languages cl on c.country_id = cl.country_id inner join languages l on l.language_id = cl.language_id  group by c.name order by count(c.country_id) desc limit 10;


-----------------------------------------------------------------------------
-- 6. What's the average number of languages in every country in a region in
--    the dataset? Show both the region's name and the average. Make sure to
--    include countries that don't have a language in your calculations.
--
--    Hint: using your previous queries and additional subqueries may
--    help
--
--    Write your query below.
-----------------------------------------------------------------------------
select r.name, avg(total_languages) as average from (select c.name, c.region_id, count(l.language) as total_languages from countries c inner join country_languages cl on c.country_id = cl.country_id inner join languages l on l.language_id = cl.language_id group by c.name)as temp inner join regions r where r.region_id = temp.region_id group by r.region_id order by average desc;


-----------------------------------------------------------------------------
-- 7. Show the country name and its "national day" for the country with
--    the most recent national day and the country with the oldest national
--    day. Do this with a *single query*.
--
--    Hint: both subqueries and union may be helpful here
--
--    The output may look like this:
--
--   name      | national_day
-- ------------+--------
-- East Timor  | 2002-05-20
-- Switzerland | 1291-08-01
--
-----------------------------------------------------------------------------
select countries.name, countries.national_day from countries where national_day = (select max(national_day) as nationalDay from countries) union select countries.name,countries.national_day from countries where national_day = (SELECT min(national_day) as nationalDay from countries);


-----------------------------------------------------------------------------
-- 8. In an SQL comment below, formulate your own question about this data
--    set and write a query to answer it.
-----------------------------------------------------------------------------
-- What is the maximum population of a country?

-- Answer:
-- +----------------+
-- |     max_pop    |
-- +----------------+
-- |    63874465000 |
-- +----------------+

select  max(total_pop) as max_pop from (select c.name as name, sum(cs.population)as total_pop from countries c inner join country_stats cs on c.country_id = cs.country_id group by name) tmp;
