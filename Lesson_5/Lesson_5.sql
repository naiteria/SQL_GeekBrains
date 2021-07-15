/*
	1. ѕусть в таблице users пол€ created_at и updated_at оказались незаполненными. «аполните их текущими датой и временем.
*/

USE shop;

INSERT INTO users(created_at, updated_at) VALUES (NOW(), NOW());

/*
	2. “аблица users была неудачно спроектирована. 
	«аписи created_at и updated_at были заданы типом VARCHAR и в них долгое врем€ помещались значени€ в формате "20.10.2017 8:10". 
	Ќеобходимо преобразовать пол€ к типу DATETIME, сохранив введеные ранее значени€.
 */

-- ¬ообще мы изначально делали правильный вариант записи данных в created_at и updated_at
-- created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
-- updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
-- но если задача стоит исправить не нашу бд, а гипотетическую, то решаетс€ такой записью:
-- UPDATE users 
-- SET 
-- created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i'),
-- updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');
-- ALTER TABLE users MODIFY column created_at DATETIME;
-- ALTER TABLE users MODIFY column updated_at DATETIME;

/*
	3. ¬ таблице складских запасов storehouses_products в поле value могут встречатьс€ самые разные цифры: 
	0, если товар закончилс€ и выше нул€, если на складе имеютс€ запасы. 
	Ќеобходимо отсортировать записи таким образом, чтобы они выводились в пор€дке увеличени€ значени€ value. 
	ќднако, нулевые запасы должны выводитьс€ в конце, после всех записей.
 */

SELECT * FROM storehouses_products ORDER BY value = 0, value;

/*
	5. (по желанию) »з таблицы catalogs извлекаютс€ записи при помощи запроса. 
	SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
	ќтсортируйте записи в пор€дке, заданном в списке IN.
 */

SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY id IN (5, 1, 2);


