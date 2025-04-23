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












