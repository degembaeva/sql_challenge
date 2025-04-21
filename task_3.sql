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
    










