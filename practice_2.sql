/*Задание
Создать таблицу fine следующей структуры:

Поле  Описание
fine_id  ключевой столбец целого типа с автоматическим увеличением значения ключа на 1
name  строка длиной 30
number_plate  строка длиной 6
violation  строка длиной 50
sum_fine  вещественное число, максимальная длина 8, количество знаков после запятой 2
date_violation  дата
date_payment  дата*/

CREATE TABLE fine(
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    number_plate CHAR(6),
    violation VARCHAR(50),
    sum_fine DECIMAL(8, 2),
    date_violation date,
    date_payment date);
    
    
/*Задание  
В таблицу fine первые 5 строк уже занесены. Добавить в таблицу записи с ключевыми значениями 6, 7, 8.*/

INSERT INTO fine(name, number_plate, violation, sum_fine, date_violation, date_payment)
VALUES
    ('Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', null, '2020-02-14', null),
    ('Абрамова К.А.', 'О111АВ', 'Проезд на запрещающий сигнал', null, '2020-02-23', null),
    ('Яковлев Г.Р.', 'Т330ТТ', 'Проезд на запрещающий сигнал', null, '2020-03-03', null);












