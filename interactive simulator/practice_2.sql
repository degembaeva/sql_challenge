/* Задание
Создать таблицу fine следующей структуры:

Поле           Описание
fine_id        ключевой столбец целого типа с автоматическим увеличением значения ключа на 1
name           строка длиной 30
number_plate   строка длиной 6
violation      строка длиной 50
sum_fine       вещественное число, максимальная длина 8, количество знаков после запятой 2
date_violation дата
date_payment   дата
*/

CREATE TABLE fine(
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    number_plate CHAR(6),
    violation VARCHAR(50),
    sum_fine DECIMAL(8, 2),
    date_violation DATE,
    date_payment DATE
);


/* Задание
В таблицу fine первые 5 строк уже занесены.
Добавить в таблицу записи с ключевыми значениями 6, 7, 8.
*/

INSERT INTO fine(name, number_plate, violation, sum_fine, date_violation, date_payment)
VALUES
('Баранов П.Е.', 'Р523ВТ', 'Превышение скорости (от 40 до 60)', NULL, '2020-02-14', NULL),
('Абрамова К.А.', 'О111АВ', 'Проезд на запрещающий сигнал', NULL, '2020-02-23', NULL),
('Яковлев Г.Р.', 'Т330ТТ', 'Проезд на запрещающий сигнал', NULL, '2020-03-03', NULL);


/* Пример
Для тех, кто уже оплатил штраф, вывести информацию о том,
изменялась ли стандартная сумма штрафа.
*/

SELECT f.name, f.number_plate, f.violation,
IF(
    f.sum_fine = tv.sum_fine, 'Стандартная сумма штрафа',
    IF(
        f.sum_fine < tv.sum_fine, 'Уменьшенная сумма штрафа',
        'Увеличенная сумма штрафа'
    )
) AS description
FROM fine f
JOIN traffic_violation tv ON tv.violation = f.violation
WHERE f.sum_fine IS NOT NULL;


/* Задание
Занести в таблицу fine суммы штрафов, которые должен оплатить водитель,
в соответствии с данными из таблицы traffic_violation.
При этом суммы заносить только в пустые поля столбца sum_fine.
*/

UPDATE fine f
JOIN traffic_violation t ON f.violation = t.violation
SET f.sum_fine = t.sum_fine
WHERE f.sum_fine IS NULL;


/* Важно!
В разделе GROUP BY нужно перечислять все НЕАГРЕГИРОВАННЫЕ столбцы из SELECT.
*/

SELECT name, number_plate, violation, COUNT(*)
FROM fine
GROUP BY name, number_plate, violation;


/* Задание
Вывести фамилию, номер машины и нарушение только для тех водителей,
которые на одной машине нарушили одно и то же правило два и более раз.
Отсортировать по фамилии, номеру машины и нарушению.
*/

SELECT name, number_plate, violation
FROM fine
GROUP BY name, number_plate, violation
HAVING COUNT(*) > 1
ORDER BY name, number_plate, violation;


/* Задание
Увеличить в два раза сумму неоплаченных штрафов
для найденных выше записей.
*/

UPDATE fine f
JOIN (
    SELECT name, number_plate, violation
    FROM fine
    GROUP BY name, number_plate, violation
    HAVING COUNT(*) > 1
) repeated
ON f.name = repeated.name
AND f.number_plate = repeated.number_plate
AND f.violation = repeated.violation
SET f.sum_fine = f.sum_fine * 2
WHERE f.date_payment IS NULL;


/* Задание
Обновить данные об оплате штрафов:
- записать дату оплаты из таблицы payment
- уменьшить штраф в 2 раза, если оплата в течение 20 дней
*/

UPDATE fine f
JOIN payment p
ON f.name = p.name
AND f.number_plate = p.number_plate
AND f.violation = p.violation
SET 
    f.date_payment = p.date_payment,
    f.sum_fine = IF(
        DATEDIFF(p.date_payment, f.date_violation) <= 20,
        f.sum_fine / 2,
        f.sum_fine
    )
WHERE f.date_payment IS NULL;


/* Задание
Создать таблицу back_payment с неоплаченными штрафами
*/

CREATE TABLE back_payment AS
SELECT name, number_plate, violation, sum_fine, date_violation
FROM fine
WHERE date_payment IS NULL;


/* Задание
Удалить нарушения, совершенные раньше 1 февраля 2020 года
*/

DELETE FROM fine
WHERE date_violation < '2020-02-01';
