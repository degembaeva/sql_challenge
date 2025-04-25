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


/*Пример

Для тех, кто уже оплатил штраф, вывести информацию о том, изменялась ли стандартная сумма штрафа.*/

SELECT  f.name, f.number_plate, f.violation, 
   if(
    f.sum_fine = tv.sum_fine, "Стандартная сумма штрафа", 
    if(
      f.sum_fine < tv.sum_fine, "Уменьшенная сумма штрафа", "Увеличенная сумма штрафа"
    )
  ) AS description               
FROM  fine f, traffic_violation tv
WHERE tv.violation = f.violation and f.sum_fine IS NOT Null;

/*Задание
Занести в таблицу fine суммы штрафов, которые должен оплатить водитель, в соответствии с данными 
из таблицы traffic_violation. При этом суммы заносить только в пустые поля столбца  sum_fine.
Таблица traffic_violationсоздана и заполнена.
Важно! Сравнение значения столбца с пустым значением осуществляется с помощью оператора IS NULL.*/

UPDATE fine f, traffic_violation t
SET f.sum_fine = t.sum_fine
WHERE f.violation = t.violation AND f.sum_fine IS NULL 


/*Важно! В разделе GROUP BY нужно перечислять все НЕАГРЕГИРОВАННЫЕ столбцы 
(к которым не применяются групповые функции) из SELECT.*/

SELECT name, number_plate, violation, count(*)
FROM fine
GROUP BY name, number_plate, violation;


/*Задание
Вывести фамилию, номер машины и нарушение только для тех водителей, которые на одной машине нарушили одно и то же 
правило   два и более раз. При этом учитывать все нарушения, независимо от того оплачены они или нет. 
Информацию отсортировать в алфавитном порядке, сначала по фамилии водителя, потом по номеру машины и, наконец, 
по нарушению.*/


SELECT name, number_plate, violation
FROM fine
GROUP BY name, number_plate, violation
HAVING COUNT(*) > 1
ORDER BY name ASC, number_plate ASC, violation ASC


/*Задание
В таблице fine увеличить в два раза сумму неоплаченных штрафов для отобранных на предыдущем шаге записей. 

Пояснение !!! если не получается запрос или валидатор выдает ошибки, раскройте это пояснение!!!
Важно! Если в запросе используется несколько таблиц или запросов, включающих одинаковые поля, то применяется 
полное имя столбца, включающего название таблицы через символ «.». Например,  fine.name  и  query_in.name.*/


UPDATE fine, (
    SELECT name, number_plate, violation
    FROM fine
    GROUP BY name, number_plate, violation
    HAVING COUNT(*) > 1
    ORDER BY name ASC, number_plate ASC, violation ASC) as query_in
SET fine.sum_fine = fine.sum_fine * 2
WHERE date_payment IS NULL AND fine.name = query_in.name  

/*2-вариант*/

UPDATE fine f
JOIN (
    SELECT name, number_plate, violation
    FROM fine
    GROUP BY name, number_plate, violation
    HAVING COUNT(*) > 1
) AS repeated
ON f.name = repeated.name
   AND f.number_plate = repeated.number_plate
   AND f.violation = repeated.violation
SET f.sum_fine = f.sum_fine * 2
WHERE f.date_payment IS NULL;


/*Пояснение пошагово:
SELECT name, number_plate, violation ... HAVING COUNT(*) > 1

Ищет водителей, у которых одно и то же нарушение встречается больше одного раза.

JOIN по трём полям:

name, number_plate, violation — чтобы точно попасть на конкретное повторение, а не просто по имени.

SET f.sum_fine = f.sum_fine * 2

Увеличиваем сумму штрафа в 2 раза.

WHERE f.date_payment IS NULL

Только для неоплаченных штрафов.*/




/*Задание
Водители оплачивают свои штрафы. В таблице payment занесены даты их оплаты:

Необходимо:
в таблицу fine занести дату оплаты соответствующего штрафа из таблицы payment; 
уменьшить начисленный штраф в таблице fine в два раза  (только для тех штрафов, информация о которых занесена в 
таблицу payment) , если оплата произведена не позднее 20 дней со дня нарушения.*/


UPDATE 
    fine, payment
SET 
    fine.date_payment = payment.date_payment,
    fine.sum_fine = IF(DATEDIFF(payment.date_payment, fine.date_violation) <= 20, fine.sum_fine / 2,fine.sum_fine)
WHERE
    fine.name = payment.name
  AND fine.number_plate = payment.number_plate
  AND fine.violation = payment.violation
  AND fine.date_payment IS NULL;




/*Задание
Создать новую таблицу back_payment, куда внести информацию о неоплаченных штрафах 
(Фамилию и инициалы водителя, номер машины, нарушение, сумму штрафа  и  дату нарушения) из таблицы fine.

Пояснение
Важно. На этом шаге необходимо создать таблицу на основе запроса! Не нужно одним запросом создавать таблицу, 
а вторым в нее добавлять строки.*/


CREATE TABLE back_payment AS
SELECT name, number_plate, violation, sum_fine, date_violation
FROM fine
WHERE date_payment IS NULL


/*Задание
Удалить из таблицы fine информацию о нарушениях, совершенных раньше 1 февраля 2020 года. */

DELETE FROM fine
WHERE date_violation < '2020-02-01'



