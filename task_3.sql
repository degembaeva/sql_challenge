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
    










