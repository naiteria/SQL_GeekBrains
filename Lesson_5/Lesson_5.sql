/*
	1. ����� � ������� users ���� created_at � updated_at ��������� ��������������. ��������� �� �������� ����� � ��������.
*/

USE shop;

INSERT INTO users(created_at, updated_at) VALUES (NOW(), NOW());

/*
	2. ������� users ���� �������� ��������������. 
	������ created_at � updated_at ���� ������ ����� VARCHAR � � ��� ������ ����� ���������� �������� � ������� "20.10.2017 8:10". 
	���������� ������������� ���� � ���� DATETIME, �������� �������� ����� ��������.
 */

-- ������ �� ���������� ������ ���������� ������� ������ ������ � created_at � updated_at
-- created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
-- updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
-- �� ���� ������ ����� ��������� �� ���� ��, � ��������������, �� �������� ����� �������:
-- UPDATE users 
-- SET 
-- created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i'),
-- updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');
-- ALTER TABLE users MODIFY column created_at DATETIME;
-- ALTER TABLE users MODIFY column updated_at DATETIME;

/*
	3. � ������� ��������� ������� storehouses_products � ���� value ����� ����������� ����� ������ �����: 
	0, ���� ����� ���������� � ���� ����, ���� �� ������ ������� ������. 
	���������� ������������� ������ ����� �������, ����� ��� ���������� � ������� ���������� �������� value. 
	������, ������� ������ ������ ���������� � �����, ����� ���� �������.
 */

SELECT * FROM storehouses_products ORDER BY value = 0, value;

/*
	5. (�� �������) �� ������� catalogs ����������� ������ ��� ������ �������. 
	SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
	������������ ������ � �������, �������� � ������ IN.
 */

SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY id IN (5, 1, 2);


