------------------------------------------------------------------------------
--      W O R K S H O P # 0 3 - M Y S Q L / M A R I A D B , J O I N S       --
------------------------------------------------------------------------------
-- WRITE QUERIES AND (FOR SOME QUESTIONS) COMMENTS BELOW. TRY TO DO THE     --
-- FIRST ~10 QUESTIONS. THE LATER QUESTIONS ARE MEANT TO BE MORE            --
-- CHALLENGING AND SOME MAY NOT EVEN HAVE STRAIGHTFORWARD ANSWERS.          --
------------------------------------------------------------------------------


------------------------------------------------------------------------------
-- 1.  What is the relationship between the tables: product_description and
--     product? Is it many-to-many, many-to-one or one-to-one? Hint: DESCRIBE
--     and SHOW CREATE TABLE may be helpful!
--     WRITE YOUR ANSWER IN AN SQL COMMENT FOLLOWED BY THE QUERIES YOU USED
--     TO ARRIVE AT YOUR ANSWER.
------------------------------------------------------------------------------
-- many-to-one
SHOW CREATE TABLE prpduct_description; -- one side
SHOW CREATE TABLE product; -- many side 

------------------------------------------------------------------------------
-- 2.  What is the relationship between the tables: report and symptom?
--     WRITE YOUR ANSWER IN AN SQL COMMENT FOLLOWED BY THE QUERIES YOU USED
--     TO ARRIVE AT YOUR ANSWER.
------------------------------------------------------------------------------
-- many-to-many relationship
SHOW CREATE TABLE report;
SHOW CREATE TABLE symptom;
SHOW CREATE TABLE report_symptom;

------------------------------------------------------------------------------
-- 3.  What is the relationship between the tables: report and product?
--     WRITE YOUR ANSWER IN AN SQL COMMENT FOLLOWED BY THE QUERIES YOU USED
--     TO ARRIVE AT YOUR ANSWER.
------------------------------------------------------------------------------
-- many-to-many relationship
SHOW CREATE TABLE report;
SHOW CREATE TABLE product;
SHOW CREATE TABLE report_product;

------------------------------------------------------------------------------
-- 4.  How many reports are in the database? Do this with a single query that 
--     results in exactly one value. 
--     WRITE YOUR ANSWER IN AN SQL COMMENT FOLLOWED BY THE QUERY BELOW.
------------------------------------------------------------------------------
-- 46198
SELECT count(*) FROM report;

------------------------------------------------------------------------------
-- 5.  What do the first 30 rows (include all columns) of reports look like 
--     when sorted by increasing report_id?
--     WRITE THE QUERY BELOW.
------------------------------------------------------------------------------

SELECT * FROM report ORDER BY report_id LIMIT 30;

------------------------------------------------------------------------------
-- 6.  How many total products are in the database? Do this with a single 
--     query that results in exactly one value. Then... with a second query,
--     show the first 30 rows, including all columns of products, this time 
--     ordering by product_id.
--     WRITE YOUR ANSWER FOR THE INITIAL QUESTION IN AN SQL COMMENT FOLLOWED 
--     BY BOTH QUERIES BELOW.
------------------------------------------------------------------------------
-- 28586

SELECT count(*) FROM product;

SELECT * FROM product ORDER BY product_id LIMIT 30;

------------------------------------------------------------------------------
-- 7.  What is the relationship between the tables: product_description and 
--     product? What are the fields contained in both tables? Which field is
--     responsible for creating the relationship between product_description
--     and product.
--     WRITE YOUR ANSWER FOR ALL QUESTIONS IN AN SQL COMMENT FOLLOWED BY THE 
--     QUERIES YOU USED TO ARRIVE AT YOUR ANSWER.
------------------------------------------------------------------------------
-- many-to-one
SHOW CREATE TABLE prpduct_description; -- one side
SHOW CREATE TABLE product; -- many side 

-- product fields
-- +--------------+--------------+------+-----+---------+----------------+
-- | Field        | Type         | Null | Key | Default | Extra          |
-- +--------------+--------------+------+-----+---------+----------------+
-- | product_id   | int(11)      | NO   | PRI | NULL    | auto_increment |
-- | name         | varchar(255) | YES  |     | NULL    |                |
-- | product_code | varchar(20)  | YES  | MUL | NULL    |                |
-- +--------------+--------------+------+-----+---------+----------------+

-- product_description fields
-- +--------------+--------------+------+-----+---------+----------------+
-- | Field        | Type         | Null | Key | Default | Extra          |
-- +--------------+--------------+------+-----+---------+----------------+
-- | product_code | varchar(20)  | NO   | PRI | NULL    |                |
-- | description  | longtext     | NO   |     | NULL    |                |
-- +--------------+--------------+------+-----+---------+----------------+

DESCRIBE product;
DESCRIBE product_description;

-- product_code is reposnsible for the one-to-many relationship

------------------------------------------------------------------------------
-- 8.  Are there any products without a product_code?
--     WRITE YOUR ANSWER IN AN SQL COMMENT FOLLOWED BY THE QUERY YOU USED TO 
--     ARRIVE AT YOUR ANSWER.
------------------------------------------------------------------------------
 -- 2407
 
 SELECT COUNT(*) FROM product WHERE product_code IS NULL;

------------------------------------------------------------------------------
-- 9.  Display 30 rows of products again, sorted by the name of the product in
--     alphabetical order. This time, however, show BOTH the NAME of the 
--     product and its DESCRIPTION. Products without an associated description 
--     should not be included. Do this without a WHERE clause.
--     WRITE YOUR QUERY BELOW.
------------------------------------------------------------------------------

SELECT prod.name, p_d.description FROM product prod INNER JOIN product_description p_d ON prod.product_code = p_d.product_code ORDER BY prod.name LIMIT 30;

------------------------------------------------------------------------------
-- 10  This part has several questions to answer:
--     
--     a. What should the possible values of product_type be based on the
--        documentation (https://www.fda.gov/media/97035/download)? 
--     b. Which table is this field located in? 
--     c. Why do you think it's included in that table?
--     d. What are the actual unique values in the database (please include the
--        correct casing) for product_type? Write a query to determine this.
--     e. Finally, find the location of the patient_age field and list out the 
--        unique possible values for it as well
--    
--     ANSWER QUESTIONS a - e IN SQL COMMENTS BELOW. WRITE YOUR QUERIES FOR 
--     FOR QUESTIONS d and e BELOW.
------------------------------------------------------------------------------
-- a. Suspect or concomitant
-- b. report_product
-- c. Because report_product is the intermediate table between reprt and product 
--    to support their many-to-many relationship. Product_type shows if the product 
--    is a suspect (may have caused the adverse recation on the patient) or if it 
--    is a concomitant (present in the patients's system). It links a patient's 
--    report to the product which is why it is included in the table report_product.
-- d. SUSPECT
--    CONCOMITANT
SELECT DISTINCT product_type FROM report_product;
-- e. report
-- 104 unique possible values for patient_age
SELECT DISTINCT patient_age FROM report;
------------------------------------------------------------------------------
-- 10. How afraid should you be of yogurt? 🙀 Show the report_id, product 
--     name and age of all reports that involved yogurt AS THE SUSPECT! 
--    
--     * again, find the rows where yogurt is suspected as the culprit for
--       the adverse reaction
--     * only include reports that have a patient's age in years
--     * sort the results by the patient's year age from oldest to youngest
--     * it's ok to hardcode strings that help your query filter:
--       * for a product name that's similar to yogurt 
--       * an age that's in years
--     * but don't hardcode any other values
--     * hint: there's probably a lot of joins involved in this one!
--     WRITE YOUR QUERY BELOW
------------------------------------------------------------------------------
SELECT rp.report_id, prod.name, rep.patient_age FROM report_product rp INNER JOIN product prod ON rp.product_id = prod.product_id INNER JOIN report rep ON rp.report_id = rep.report_id WHERE rp.product_type = "SUSPECT" AND prod.name LIKE "%yogurt%" AND rep.age_units = "year(s)" ORDER BY rep.patient_age DESC;

------------------------------------------------------------------------------
-- 10. Are there any reports that include more than one product as a 
--     SUSPECT? 🕵️ A yes or no answer is adequate, but write a single query 
--     support your answer. Hint: can you show both the report id and the 
--     number of products that are suspect that it's associated with? Taken a 
--     step further, only show the reports that have more than 1 suspect 
--     product.
--
--     WRITE YOUR ANSWER AND QUERY BELOW
------------------------------------------------------------------------------
SELECT COUNT(*) FROM report_product WHERE product_type = "SUSPECT" GROUP BY report_id HAVING COUNT(product_id) > 1; 

------------------------------------------------------------------------------
-- 11. Let's try using subqueries! Use your query above as a foundation. Find
--     the average (AVG) number of products per report that has more than one
--     suspect product. 😑
--    
--     * put your previous query in parentheses so that it can be used as an
--       "inner" query
--     * add a name after the parentheses to alias it (for example, tmp) so
--       so that you can refer to it in your outer query
--     * in your inner query, if you did not do so in your previous answer,
--       make sure all items in the select list are easily accessible (that
--       is, give expressions in your select list an alias with as)
--     * prior to your subquery,  you can use a select statement, but with
--       your subquery following from
--
--     WRITE YOUR ANSWER AND QUERY OR QUERIES BELOW
------------------------------------------------------------------------------
-- 2.2703
SELECT AVG(p) FROM (SELECT COUNT(*) AS p FROM report_product WHERE product_type = "SUSPECT" GROUP BY report_id HAVING COUNT(product_id) > 1) as tmp; 
------------------------------------------------------------------------------
-- 12. Find the name, product code, and symptom (term) of all of the products 
--     (no duplicates) that give you nightmares 😱
-- 
--     * again, it's ok to hardcode the part of your query that searches for
--       nightmares, but do not hardcode anything else, though
--     * only show the first 30 results
--     * sort by name, ascending
--     * hint: there's even more joins!
--     WRITE YOUR QUERY BELOW
------------------------------------------------------------------------------
-- 
SELECT DISTINCT p.name, p.product_code, s.term FROM symptom s INNER JOIN report_symptom rs ON s.symptom_id = rs.symptom_id INNER JOIN report_product rp ON rs.report_id = rp.report_id INNER JOIN product p ON p.product_id = rp.product_id WHERE s.term LIKE "%nightmare%" ORDER BY p.name LIMIT 30;
------------------------------------------------------------------------------
-- 13. When were the most recently entered reports (use the date that the 
--     report was made rather than when the "event" happened)? 📅
-- 
--     This is actually two queries:
--
--     1. find the date of the most recently entered report(s) 
--     2. reuse that query as part of a subquery to display the report id, 
--        product name, and the date of the most recently entered event(s)
--        * do not hardcode a limit
--
--     WRITE YOUR QUERY BELOW
------------------------------------------------------------------------------

SELECT MAX(created_date) FROM report;

SELECT r.report_id p.name, r.event_date FROM report r INNER JOIN report_product rp ON r.report_id = rp.report_id INNER JOIN product p ON p.product_id = rp.product_id WHERE r.created_date =(SELECT MAX(created_date) FROM report);

------------------------------------------------------------------------------
-- 14. What are the 3 most common symptoms 🤮
--     
--     * include the name of the symptom and the count
--     * sorted by the count from greatest to least
--
--     WRITE YOUR QUERY BELOW
------------------------------------------------------------------------------
SELECT s.term AS name, count(rs.symptom_id) AS count FROM symptom s INNER JOIN report_symptom rs ON s.symptom_id = rs.symptom_id GROUP BY rs.symptom_id ORDER BY COUNT(rs.symptom_id) DESC LIMIT 3;

------------------------------------------------------------------------------
-- 15. Find the event that had the most symptoms (there could be a tie) 🤒
-- 
--     * show the primary key for the report, the created date, event date, 
--       product, description, patient_age, sex, and all symptom terms, along 
--       with the count of symptoms
--     * do this for all non exempt products (EXEMPT 4)
--
--     WRITE YOUR QUERY BELOW
------------------------------------------------------------------------------
SELECT r.report_id, r.created_date, r.event_date, p.name, pd.description, r.patient_age, r.sex, s.term, COUNT(term) AS symptom_count FROM report r INNER JOIN report_symptom rs ON rs.report_id = r.report_id INNER JOIN symptom s ON s.symptom_id = rs.symptom_id INNER JOIN report_product rp ON rp.report_id = r.report_id INNER JOIN product p ON rp.product_id = p.product_id INNER JOIN product_description pd ON pd.product_code = p.product_code WHERE p.name NOT LIKE "EXEMPT%" GROUP BY r.report_id ORDER BY symptom_count DESC LIMIT 1;


------------------------------------------------------------------------------
-- 16. Show a comma separated list of symptoms / terms for every report 📝
-- 
--     * the symptoms should look something like: DIZZINESS,RASH,FEVER
--     * use the aggregate function, group_concat, to do this:
--       https://mariadb.com/kb/en/group_concat/
--     * include the report_id and list out the results sorted by the 
--       report_id
--     * only show 5 results
--
--     WRITE YOUR QUERY BELOW
------------------------------------------------------------------------------
SELECT r.report_id, GROUP_CONCAT(s.term) AS symptoms FROM report r INNER JOIN report_symptom rs ON rs.report_id = r.report_id INNER JOIN symptom s ON s.symptom_id = rs.symptom_id GROUP BY report_id ORDER BY report_id LIMIT 5;