/*�������
������� ������� fine ��������� ���������:

����  ��������
fine_id  �������� ������� ������ ���� � �������������� ����������� �������� ����� �� 1
name  ������ ������ 30
number_plate  ������ ������ 6
violation  ������ ������ 50
sum_fine  ������������ �����, ������������ ����� 8, ���������� ������ ����� ������� 2
date_violation  ����
date_payment  ����*/

CREATE TABLE fine(
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    number_plate CHAR(6),
    violation VARCHAR(50),
    sum_fine DECIMAL(8, 2),
    date_violation date,
    date_payment date);
    
    
/*�������  
� ������� fine ������ 5 ����� ��� ��������. �������� � ������� ������ � ��������� ���������� 6, 7, 8.*/

INSERT INTO fine(name, number_plate, violation, sum_fine, date_violation, date_payment)
VALUES
    ('������� �.�.', '�523��', '���������� ��������(�� 40 �� 60)', null, '2020-02-14', null),
    ('�������� �.�.', '�111��', '������ �� ����������� ������', null, '2020-02-23', null),
    ('������� �.�.', '�330��', '������ �� ����������� ������', null, '2020-03-03', null);


/*������

��� ���, ��� ��� ������� �����, ������� ���������� � ���, ���������� �� ����������� ����� ������.*/

SELECT  f.name, f.number_plate, f.violation, 
   if(
    f.sum_fine = tv.sum_fine, "����������� ����� ������", 
    if(
      f.sum_fine < tv.sum_fine, "����������� ����� ������", "����������� ����� ������"
    )
  ) AS description               
FROM  fine f, traffic_violation tv
WHERE tv.violation = f.violation and f.sum_fine IS NOT Null;

/*�������
������� � ������� fine ����� �������, ������� ������ �������� ��������, � ������������ � ������� 
�� ������� traffic_violation. ��� ���� ����� �������� ������ � ������ ���� �������  sum_fine.
������� traffic_violation������� � ���������.
�����! ��������� �������� ������� � ������ ��������� �������������� � ������� ��������� IS NULL.*/

UPDATE fine f, traffic_violation t
SET f.sum_fine = t.sum_fine
WHERE f.violation = t.violation AND f.sum_fine IS NULL 


/*�����! � ������� GROUP BY ����� ����������� ��� ���������������� ������� 
(� ������� �� ����������� ��������� �������) �� SELECT.*/

SELECT name, number_plate, violation, count(*)
FROM fine
GROUP BY name, number_plate, violation;


/*�������
������� �������, ����� ������ � ��������� ������ ��� ��� ���������, ������� �� ����� ������ �������� ���� � �� �� 
�������   ��� � ����� ���. ��� ���� ��������� ��� ���������, ���������� �� ���� �������� ��� ��� ���. 
���������� ������������� � ���������� �������, ������� �� ������� ��������, ����� �� ������ ������ �, �������, 
�� ���������.*/


SELECT name, number_plate, violation
FROM fine
GROUP BY name, number_plate, violation
HAVING COUNT(*) > 1
ORDER BY name ASC, number_plate ASC, violation ASC


/*�������
� ������� fine ��������� � ��� ���� ����� ������������ ������� ��� ���������� �� ���������� ���� �������. 

��������� !!! ���� �� ���������� ������ ��� ��������� ������ ������, ��������� ��� ���������!!!
�����! ���� � ������� ������������ ��������� ������ ��� ��������, ���������� ���������� ����, �� ����������� 
������ ��� �������, ����������� �������� ������� ����� ������ �.�. ��������,  fine.name  �  query_in.name.*/


UPDATE fine, (
    SELECT name, number_plate, violation
    FROM fine
    GROUP BY name, number_plate, violation
    HAVING COUNT(*) > 1
    ORDER BY name ASC, number_plate ASC, violation ASC) as query_in
SET fine.sum_fine = fine.sum_fine * 2
WHERE date_payment IS NULL AND fine.name = query_in.name  

/*2-�������*/

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


/*��������� ��������:
SELECT name, number_plate, violation ... HAVING COUNT(*) > 1

���� ���������, � ������� ���� � �� �� ��������� ����������� ������ ������ ����.

JOIN �� ��� �����:

name, number_plate, violation � ����� ����� ������� �� ���������� ����������, � �� ������ �� �����.

SET f.sum_fine = f.sum_fine * 2

����������� ����� ������ � 2 ����.

WHERE f.date_payment IS NULL

������ ��� ������������ �������.*/




/*�������
�������� ���������� ���� ������. � ������� payment �������� ���� �� ������:

����������:
� ������� fine ������� ���� ������ ���������������� ������ �� ������� payment; 
��������� ����������� ����� � ������� fine � ��� ����  (������ ��� ��� �������, ���������� � ������� �������� � 
������� payment) , ���� ������ ����������� �� ������� 20 ���� �� ��� ���������.*/


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




/*�������
������� ����� ������� back_payment, ���� ������ ���������� � ������������ ������� 
(������� � �������� ��������, ����� ������, ���������, ����� ������  �  ���� ���������) �� ������� fine.

���������
�����. �� ���� ���� ���������� ������� ������� �� ������ �������! �� ����� ����� �������� ��������� �������, 
� ������ � ��� ��������� ������.*/


CREATE TABLE back_payment AS
SELECT name, number_plate, violation, sum_fine, date_violation
FROM fine
WHERE date_payment IS NULL


/*�������
������� �� ������� fine ���������� � ����������, ����������� ������ 1 ������� 2020 ����. */

DELETE FROM fine
WHERE date_violation < '2020-02-01'



