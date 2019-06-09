/*=====================================================================================
Just simple CASE statements to practice using a Udacity db.
=====================================================================================*/


/*1.	We would like to understand 3 different levels of customers based on the amount 
associated with their purchases. The top branch includes anyone with a Lifetime Value 
(total sales of all orders) greater than 200,000 usd. The second branch is between 
200,000 and 100,000 usd. The lowest branch is anyone under 100,000usd. Provide a table 
that includes the level associated with each account. You should provide the account 
name, the total sales of all orders for the customer, and the level. Order with the 
top spending customers listed first.*/

SELECT a.name,
    SUM(o.total_amt_us) AS total,
    CASE WHEN SUM(o.total_amt_usd) > 200000
        THEN '+200k'
        WHEN SUM(o.total_amt_usd) > 100000
            AND SUM(o.total_amt_usd) <= 200000
        THEN '100k - 200k'
        ELSE '-100k'
        END AS level
 FROM orders o
 JOIN accounts a
   ON a.id = 0.account_id
 GROUP BY 1
 ORDER BY 2 DESC;
 


 /*2.	We would like to identify top performing sales reps, which are sales reps 
 associated with more than 200 orders. Create a table with the sales rep name, the total 
 number of orders, and a column with top or not depending on if they have more than 200 
 orders. Place the top sales people first in your final table.*/
 
SELECT s.name,
       COUNT(o.*) AS orders,
       CASE WHEN COUNT(0.*) > 200
       THEN 'TOP'
       ELSE 'NOT'
       END AS performance
  FROM orders o
  JOIN accounts a
    ON o.account_id = a.id
  JOIN sales_reps s
    ON s.id = a.sales_rep_id
GROUP BY 1
ORDER BY 2 DESC;


/* ADVANCED SQL QUIZ
We want to find out the most popular music Genre for each country. We determine the most 
popular genre as the genre with the highest amount of purchases. Write a query that returns 
each country along with the top Genre. For countries where the maximum number of purchases 
is share, return all Genres. The purchases column shows the number of purchases. So to answer 
the question you need to find the genre with the maximum number of purchases in each country.*/

WITH t1 AS (SELECT MAX(Purchases) buys,
            sub.Country
            FROM (SELECT COUNT (*) AS Purchases
                         Customer.Country Country,
                         Genre.Name Name,
                         Genre.GenreId GenreId
                  FROM Genre
                  JOIN Track
                    ON Genre.GenreId = Track.GenreID
                  JOIN InvoiceLine
                    ON Track.TrackId = InvoiceLine.TrackId
                  JOIN Invoice
                    ON InvoiceLine.InvoiceId = Invoice.InvoiceId
                  JOIN Customer
                    ON Invoice.CustomerId = Customer.CustomerId
            GROUP BY 3, 4, 2
            ORDER BY 2) AS sub
            GROUP BY 2
            ORDER BY 2)
            
SELECT COUNT(*) As Purchases,
       Customer.Country,
       Genre.Name Name,
       Genre.GenreId GenreId
  FROM Genre
  JOIN Track
    ON Genre.GenreId = Track.GenreId
  JOIN InvoiceLine
    ON Track.TrackId = InvoiceLine.TrackId
  JOIN Invoice
    ON InvoiceLine.InvoiceId = Invoice.InvoiceId
  JOIN Customer
    ON Invoice.CustomerId = Cusgtomer.CustomerId
  JOIN t1
    ON t1.Country = Customer.Country
GROUP BY 3, 4, 2
HAVING Purchases = t1.buys
ORDER BY 2;

WITH t1 AS (SELECT MAX(totalstuff) AS maxtotal,
            sub.country
FROM (SELECT SUM(i.total) AS totalstuff,
      c.country,
      c.firstname,
      c.lastname,
      c.customerid
      FROM customer c
      JOIN invoice i
        ON c.customerid = i.customerid
      GROUP BY 5, 2, 3, 4
      ORDER BY 2 DESC) AS sub
            GROUP BY 2
            ORDER BY 2)

SELECT c.country,
      SUM(i.total) AS totalthing,
      c.firstname,
      c.lastname,
      c.customerid
 FROM customer c
 JOIN invoice i
   ON c.customerid = i.customerid
 JOIN t1
   ON t1.country = c.country
GROUP BY 5, 1, 3, 4
HAVING totalthing = t1.maxtotal
ORDER BY 1;
