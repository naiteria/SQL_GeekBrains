/*
	1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
*/

USE shop;

INSERT INTO users(created_at, updated_at) VALUES (NOW(), NOW());

/*
	2. Таблица users была неудачно спроектирована. 
	Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". 
	Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
 */

-- Вообще мы изначально делали правильный вариант записи данных в created_at и updated_at
-- created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
-- updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
-- но если задача стоит исправить не нашу бд, а гипотетическую, то решается такой записью:
-- UPDATE users 
-- SET 
-- created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i'),
-- updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');
-- ALTER TABLE users MODIFY column created_at DATETIME;
-- ALTER TABLE users MODIFY column updated_at DATETIME;

/*
	3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
	0, если товар закончился и выше нуля, если на складе имеются запасы. 
	Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
	Однако, нулевые запасы должны выводиться в конце, после всех записей.
 */

SELECT * FROM storehouses_products ORDER BY value = 0, value;

/*
	5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. 
	SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
	Отсортируйте записи в порядке, заданном в списке IN.
 */

SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY id IN (5, 1, 2);

