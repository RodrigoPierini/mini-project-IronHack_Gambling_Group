USE gambling;
/*Question 1*/
SELECT Title, FirstName, LastName, DateOfBirth
FROM customer;


/*Question 2*/
SELECT CustomerGroup, COUNT(CustId)
FROM customer
GROUP BY CustomerGroup
ORDER BY COUNT(CustId);


/*Question 3*/
SELECT customer.*, account.CurrencyCode
FROM customer INNER JOIN account
ON customer.CustId = account.CustId;


/*Question 4*/
/*
SELECT betting.product, betting.BetDate, SUM(Bet_Amt) AS Bet_Amt
FROM betting
GROUP BY betting.product, betting.BetDate
ORDER BY betting.product, (STR_TO_DATE(betting.BetDate, '%m/%d/%Y'));
*/


SELECT betting.product, product.sub_product, betting.BetDate, SUM(Bet_Amt) AS Bet_Amt
FROM betting INNER JOIN product
ON betting.ClassId = product.CLASSID
GROUP BY betting.product, product.sub_product, betting.BetDate
ORDER BY betting.product DESC, DATE(STR_TO_DATE(betting.BetDate, '%m/%d/%Y'));




/*Question 5*/
/*
SELECT betting.product, betting.BetDate, SUM(Bet_Amt) AS Bet_Amt
FROM betting
WHERE MONTH(STR_TO_DATE(betting.BetDate, '%m/%d/%Y')) >= 11 AND betting.product = 'Sportsbook'
GROUP BY betting.product, betting.BetDate
ORDER BY (STR_TO_DATE(betting.BetDate, '%m/%d/%Y'));
*/


SELECT betting.product, product.sub_product, betting.BetDate, SUM(Bet_Amt) AS Bet_Amt
FROM betting INNER JOIN product
ON betting.ClassId = product.CLASSID
WHERE MONTH(STR_TO_DATE(betting.BetDate, '%m/%d/%Y')) >= 11 AND betting.product = 'Sportsbook'
GROUP BY betting.product, product.sub_product, betting.BetDate
ORDER BY betting.product DESC, DATE(STR_TO_DATE(betting.BetDate, '%m/%d/%Y'));




/*Question 6*/
SELECT account.CurrencyCode, customer.CustomerGroup, betting.product, SUM(betting.Bet_Amt) AS Bet_Amt
FROM customer INNER JOIN account
ON customer.CustId = account.CustId
INNER JOIN betting
ON account.AccountNo = betting.AccountNo
WHERE MONTH(STR_TO_DATE(betting.BetDate, '%m/%d/%Y')) >= 12
GROUP BY account.CurrencyCode, customer.CustomerGroup, betting.product
ORDER BY account.CurrencyCode, customer.CustomerGroup;


/*Question 7*/
SELECT Title, FirstName, LastName, SUM(Bet_Amt) AS Bet_Amt
FROM customer INNER JOIN account
ON customer.CustId = account.CustId
INNER JOIN betting
ON account.AccountNo = betting.AccountNo
WHERE MONTH(STR_TO_DATE(betting.BetDate, '%m/%d/%Y')) = 11
GROUP BY Title, FirstName, LastName
ORDER BY Bet_Amt;


/*Question 8*/
/*Number of products per player*/
SELECT Title, FirstName, LastName, COUNT(DISTINCT betting.Product) AS Num_of_Products
FROM customer INNER JOIN account
ON customer.CustId = account.CustId
INNER JOIN betting
ON account.AccountNo = betting.AccountNo
GROUP BY Title, FirstName, LastName
ORDER BY Num_of_Products DESC;

/*Players who play both Sportsbook and Vegas*/
SELECT Title, FirstName, LastName
FROM customer INNER JOIN account
ON customer.CustId = account.CustId
INNER JOIN betting
ON account.AccountNo = betting.AccountNo
WHERE betting.Product IN ('Sportsbook', 'Vegas')
GROUP BY Title, FirstName, LastName
HAVING COUNT(DISTINCT product) = 2
ORDER BY Title, FirstName, LastName;


/*Question 9*/
SELECT Title, FirstName, LastName, SUM(Bet_Amt) AS Bet_Amt
FROM customer INNER JOIN account
ON customer.CustId = account.CustId
INNER JOIN betting
ON account.AccountNo = betting.AccountNo
WHERE betting.Product ='Sportsbook'
GROUP BY Title, FirstName, LastName
HAVING SUM(Bet_Amt) > 0
ORDER BY Bet_Amt;


/*Question 10*/
SELECT c.Title, c.FirstName, c.LastName, b.Product, b.BetTotal
FROM customer c 
INNER JOIN account a 
ON c.CustId = a.CustId 
INNER JOIN 
    (SELECT 
        a.CustId, 
        b.Product, 
        SUM(b.Bet_Amt) AS BetTotal 
    FROM 
        account a 
    INNER JOIN 
        betting b ON a.AccountNo = b.AccountNo 
    GROUP BY 
        a.CustId, 
        b.Product) b ON c.CustId = b.CustId
INNER JOIN 
    (SELECT 
        CustId, 
        MAX(BetTotal) AS MaxBetTotal 
    FROM 
        (SELECT 
            a.CustId, 
            b.Product, 
            SUM(b.Bet_Amt) AS BetTotal 
        FROM 
            account a 
        INNER JOIN 
            betting b ON a.AccountNo = b.AccountNo 
        GROUP BY 
            a.CustId, 
            b.Product) sub 
    GROUP BY 
        CustId) max_bet ON b.CustId = max_bet.CustId AND b.BetTotal = max_bet.MaxBetTotal
ORDER BY 
    c.FirstName;
    
    
/*Question 11*/
USE student_school;

SELECT student_name, GPA
FROM student
ORDER BY GPA DESC
LIMIT 5;


/*Question 12*/
SELECT school.school_name, COUNT(student.student_name) AS Num_Students
FROM school LEFT JOIN student
ON school.school_id = student.school_id
GROUP BY school.school_name
ORDER BY Num_Students;


/*Question 13*/
/*
SELECT school.school_name, student.student_name, student.GPA
FROM school LEFT JOIN student
ON school.school_id = student.school_id
GROUP BY school.school_name, student.student_name, student.GPA
ORDER BY student.GPA DESC;
*/


SELECT school_name, student_name, GPA 
FROM 
	(SELECT school.school_name, student.student_name, student.GPA, ROW_NUMBER() OVER (PARTITION BY school.school_id ORDER BY GPA DESC) AS row_num 
		FROM school LEFT JOIN student 
		ON school.school_id = student.school_id ) AS ranked_data
WHERE row_num <= 3;







