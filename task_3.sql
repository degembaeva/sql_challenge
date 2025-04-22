/*������

������� ��� ����� �� ������� supply � ������� book.*/

INSERT INTO book (title, author, price, amount) 
SELECT title, author, price, amount 
FROM supply;

SELECT * FROM book;

/*� �������� �� ���������� ����� ������������ ��������� �������.

������

������� �� ������� supply � ������� book ������ �� �����, �������� ������� ����������� � ������� book.*/

INSERT INTO book (title, author, price, amount) 
SELECT title, author, price, amount 
FROM supply
WHERE title NOT IN (
        SELECT title 
        FROM book
      );

SELECT * FROM book;



/*�������
������� �� ������� supply � ������� book ������ �� �����, ������� ������� ��� �  book.*/

INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount
FROM supply
WHERE author NOT IN(
    SELECT author 
    FROM book);

SELECT * FROM book;



/*��������� ������� � ������� ����������� � ������� ������� UPDATE. ���������� ������ ��  ���������� �������� ���:

UPDATE ������� SET ���� = ���������
��� 
������� � ��� �������, � ������� ����� ����������� ���������;
���� � ���� �������, � ������� ����� ������� ���������;
��������� � ���������,  �������� �������� ����� �������� � ����.*/

/*������

��������� �� 30% ���� ���� � ������� book.*/


UPDATE book 
SET price = 0.7 * price;

SELECT * FROM book;


/*������

��������� �� 30% ���� ��� ���� � ������� book, ���������� ������� ������ 5.*/

UPDATE book 
SET price = 0.7 * price 
WHERE amount < 5;

SELECT * FROM book;


/*�������
��������� �� 10% ���� ��� ���� � ������� book, ���������� ������� ����������� ��������� �� 5 �� 10, ������� �������.*/

UPDATE book
SET price = 0.9 * price
WHERE amount BETWEEN 5 AND 10;


SELECT * FROM book;

/*������

� ������� buy ���������� ��������� ���������� ����, ������� �� ����� ����������. ��� ������ �����, ��������� �����������, 
���������� ��������� �� ���������� �� ������ �� ��������� � �������buy ����������, � � ������� buy ������� 0.*/

UPDATE book 
SET amount = amount - buy,
    buy = 0;

SELECT * FROM book;

/*2-�������, ���� ������ ������� ������ �� ������, ��� ���������� ���������� ���� �� ��������� ���������� �� ������.*/
UPDATE book 
SET amount = amount - buy,
    buy = 0
WHERE buy <= amount;

/*�������
� ������� book ���������� ��������������� �������� ��� ���������� � ������� buy ����� �������, 
����� ��� �� ��������� ���������� ����������� ����, ��������� � ������� amount. � ���� ��� ����, 
������� ���������� �� ���������, ������� �� 10%.*/

UPDATE book
SET buy = IF(buy > amount, amount, buy),
    price = IF(buy = 0, price*0.9, price)
    

/*������

���� � ������� supply  ���� �� �� �����, ��� � � ������� book, ��������� ��� ����� � ������� book �� ����� ������. 
���������� ��������� �� ���������� �� �������� ������� amount������� supply.*/


UPDATE book, supply 
SET book.amount = book.amount + supply.amount
WHERE book.title = supply.title AND book.author = supply.author;

SELECT * FROM book;





/*�������
��� ��� ���� � ������� book , ������� ���� � ������� supply, �� ������ ��������� �� ���������� � ������� book 
( ��������� �� ���������� �� �������� ������� amount������� supply), �� � ����������� �� ���� 
(��� ������ ����� ����� ����� ��� �� ������ book � supply � ��������� �� 2).*/


UPDATE book, supply
SET book.amount = supply.amount + book.amount,
    book.price = (book.price+supply.price)/2
WHERE book.title = supply.title AND book.author = supply.author




/*������

������� �� ������� supply ��� �����, �������� ������� ���� � ������� book.*/

DELETE FROM supply 
WHERE title IN (
        SELECT title 
        FROM book
      );


SELECT * FROM supply;

/*�������
������� �� ������� supply ����� ��� �������, ����� ���������� ����������� ���� ������� � ������� book ��������� 10.*/
DELETE FROM supply
WHERE author IN (SELECT author FROM book
                   GROUP BY author
                   HAVING SUM(amount) > 10)
                   
                   
/*������
������� ������� ����� (ordering), ���� �������� ������� � �������� ��� ����, ���������� ����������� ������� 
� ������� book ������ 4. ��� ���� ���� ������� ���������� ���������� ����������� 5.*/


CREATE TABLE ordering AS
SELECT author, title, 5 AS amount
FROM book
WHERE amount < 4;

SELECT * FROM ordering;


/*������

������� ������� ����� (ordering), ���� �������� ������� � �������� ��� ����, ���������� ����������� ������� � 
������� book ������ 4. ��� ���� ���� ������� ���������� �������� - ������� ���������� ����������� ���� 
� ������� book.*/


CREATE TABLE ordering AS
SELECT author, title, 
   (
    SELECT ROUND(AVG(amount)) 
    FROM book
   ) AS amount
FROM book
WHERE amount < 4;

SELECT * FROM ordering;


/*�������
������� ������� ����� (ordering), ���� �������� ������� � �������� ��� ����, ���������� ����������� 
������� � ������� book ������ �������� ���������� ����������� ���� � ������� book. 
� ������� �������� �������   amount, � ������� ��� ���� ���� ������� ���������� �������� - ������� ���������� 
����������� ���� � ������� book.*/

CREATE TABLE ordering AS
SELECT author, title,
       (SELECT ROUND(AVG(amount)) FROM book) AS amount
FROM book
WHERE amount < (
       SELECT AVG(amount) FROM book
);














