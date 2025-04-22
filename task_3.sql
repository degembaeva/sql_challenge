/*Пример

Занести все книги из таблицы supply в таблицу book.*/

INSERT INTO book (title, author, price, amount) 
SELECT title, author, price, amount 
FROM supply;

SELECT * FROM book;

/*В запросах на добавление можно использовать вложенные запросы.

Пример

Занести из таблицы supply в таблицу book только те книги, названия которых отсутствуют в таблице book.*/

INSERT INTO book (title, author, price, amount) 
SELECT title, author, price, amount 
FROM supply
WHERE title NOT IN (
        SELECT title 
        FROM book
      );

SELECT * FROM book;



/*Задание
Занести из таблицы supply в таблицу book только те книги, авторов которых нет в  book.*/

INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount
FROM supply
WHERE author NOT IN(
    SELECT author 
    FROM book);

SELECT * FROM book;



/*Изменение записей в таблице реализуется с помощью запроса UPDATE. Простейший запрос на  обновление выглядит так:

UPDATE таблица SET поле = выражение
где 
таблица – имя таблицы, в которой будут проводиться изменения;
поле – поле таблицы, в которое будет внесено изменение;
выражение – выражение,  значение которого будет занесено в поле.*/

/*Пример

Уменьшить на 30% цену книг в таблице book.*/


UPDATE book 
SET price = 0.7 * price;

SELECT * FROM book;


/*Пример

Уменьшить на 30% цену тех книг в таблице book, количество которых меньше 5.*/

UPDATE book 
SET price = 0.7 * price 
WHERE amount < 5;

SELECT * FROM book;


/*Задание
Уменьшить на 10% цену тех книг в таблице book, количество которых принадлежит интервалу от 5 до 10, включая границы.*/

UPDATE book
SET price = 0.9 * price
WHERE amount BETWEEN 5 AND 10;


SELECT * FROM book;

/*Пример

В столбце buy покупатель указывает количество книг, которые он хочет приобрести. Для каждой книги, выбранной покупателем, 
необходимо уменьшить ее количество на складе на указанное в столбцеbuy количество, а в столбец buy занести 0.*/

UPDATE book 
SET amount = amount - buy,
    buy = 0;

SELECT * FROM book;

/*2-вариант, этот запрос обновит только те строки, где количество заказанных книг не превышает количество на складе.*/
UPDATE book 
SET amount = amount - buy,
    buy = 0
WHERE buy <= amount;

/*Задание
В таблице book необходимо скорректировать значение для покупателя в столбце buy таким образом, 
чтобы оно не превышало количество экземпляров книг, указанных в столбце amount. А цену тех книг, 
которые покупатель не заказывал, снизить на 10%.*/

UPDATE book
SET buy = IF(buy > amount, amount, buy),
    price = IF(buy = 0, price*0.9, price)
    

/*Пример

Если в таблице supply  есть те же книги, что и в таблице book, добавлять эти книги в таблицу book не имеет смысла. 
Необходимо увеличить их количество на значение столбца amountтаблицы supply.*/


UPDATE book, supply 
SET book.amount = book.amount + supply.amount
WHERE book.title = supply.title AND book.author = supply.author;

SELECT * FROM book;





/*Задание
Для тех книг в таблице book , которые есть в таблице supply, не только увеличить их количество в таблице book 
( увеличить их количество на значение столбца amountтаблицы supply), но и пересчитать их цену 
(для каждой книги найти сумму цен из таблиц book и supply и разделить на 2).*/


UPDATE book, supply
SET book.amount = supply.amount + book.amount,
    book.price = (book.price+supply.price)/2
WHERE book.title = supply.title AND book.author = supply.author




/*Пример

Удалить из таблицы supply все книги, названия которых есть в таблице book.*/

DELETE FROM supply 
WHERE title IN (
        SELECT title 
        FROM book
      );


SELECT * FROM supply;

/*Задание
Удалить из таблицы supply книги тех авторов, общее количество экземпляров книг которых в таблице book превышает 10.*/
DELETE FROM supply
WHERE author IN (SELECT author FROM book
                   GROUP BY author
                   HAVING SUM(amount) > 10)
                   
                   
/*Пример
Создать таблицу заказ (ordering), куда включить авторов и названия тех книг, количество экземпляров которых 
в таблице book меньше 4. Для всех книг указать одинаковое количество экземпляров 5.*/


CREATE TABLE ordering AS
SELECT author, title, 5 AS amount
FROM book
WHERE amount < 4;

SELECT * FROM ordering;


/*Пример

Создать таблицу заказ (ordering), куда включить авторов и названия тех книг, количество экземпляров которых в 
таблице book меньше 4. Для всех книг указать одинаковое значение - среднее количество экземпляров книг 
в таблице book.*/


CREATE TABLE ordering AS
SELECT author, title, 
   (
    SELECT ROUND(AVG(amount)) 
    FROM book
   ) AS amount
FROM book
WHERE amount < 4;

SELECT * FROM ordering;


/*Задание
Создать таблицу заказ (ordering), куда включить авторов и названия тех книг, количество экземпляров 
которых в таблице book меньше среднего количества экземпляров книг в таблице book. 
В таблицу включить столбец   amount, в котором для всех книг указать одинаковое значение - среднее количество 
экземпляров книг в таблице book.*/

CREATE TABLE ordering AS
SELECT author, title,
       (SELECT ROUND(AVG(amount)) FROM book) AS amount
FROM book
WHERE amount < (
       SELECT AVG(amount) FROM book
);














