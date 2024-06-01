
--Q1.Identify top 3 transactions for each Region based on Sales.

SELECT * FROM (SELECT
    `Emp ID`,
    Region,
    Name,
    Department,
    `Month`,
    `Year`,
    `Date`,
    Sales,
    DENSE_RANK() OVER(
        PARTITION BY Region
        ORDER BY
            Sales DESC
    ) as sale_rank
FROM
    mytable) AS sub
WHERE sale_rank <=3;






--Q2.Change the Date format (MM/DD/YYYY) (Posting Date) (Main Table)

UPDATE mytable
SET Date = CASE
    WHEN INSTR(Date, '-') > 0 THEN DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%m/%d/%Y') -- for DD-MM-YYYY
    ELSE DATE_FORMAT(STR_TO_DATE(Date, '%m/%d/%Y'), '%m/%d/%Y') -- for MM/DD/YYYY
END;



--                        OR Without affecting the main table

SELECT
    CASE
        WHEN INSTR(`Date`, '-') > 0 THEN DATE_FORMAT(STR_TO_DATE(`Date`, '%d-%m-%Y'), '%m/%d/%Y') -- for DD - MM - YYYY
        ELSE `Date`
    END AS Date_sales
FROM
    mytable;





--Q3.Calculate the % of sales and % Discount in the above table

SELECT *,ROUND((Sales / (SELECT SUM(Sales) FROM mytable))*100,2) as `%Sales`,ROUND((Discounts / (SELECT SUM(Discounts) FROM mytable))*100,2) as `%Discounts` FROM mytable;






--Q4.Write the SQL query to update the Category in table 1 using reference table 2

UPDATE mytable AS t1
JOIN table2 AS t2 ON t1.Department = t2.Department
SET t1.Category = t2.Category;

SELECT * FROM mytable;





--Q5.Find the minimum and maximum sales of each Department

SELECT Department,MIN(Sales) as minimum_sales,MAX(Sales) as maximum_sales FROM mytable
GROUP BY Department;





--Q6.Write the SQL query to Add the rank of each Emp ID based on total sales.


WITH rank_sales AS (
    SELECT
        `Emp ID`,
        SUM(Sales) AS TotalSales,
        ROW_NUMBER() OVER (ORDER BY SUM(Sales) DESC) AS rank_sales
    FROM
        mytable
    GROUP BY
        `Emp ID`
)
SELECT
    mytable.*,
    rank_sales
FROM
    mytable
JOIN
    rank_sales ON mytable.`Emp ID` = rank_sales.`Emp ID`;

