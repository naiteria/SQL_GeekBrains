DROP DATABASE IF EXISTS vk;

CREATE DATABASE vk;
-- используем бд vk
USE vk;
-- показываем все таблицы
SHOW tables;
-- Создаем таблицу users
CREATE TABLE IF NOT EXISTS users(
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(145) NOT NULL,
	last_name VARCHAR(145) NOT NULL,
	email VARCHAR(145) NOT NULL UNIQUE,
	phone CHAR(11),
	password_hash CHAR(65) DEFAULT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	INDEX (phone),
	INDEX (email)
);

-- Заполняем таблицу
INSERT INTO users VALUES (DEFAULT, 'Petay', 'Petuchov', 'petay@mail.ru', '89212223034', DEFAULT, DEFAULT);
INSERT INTO users VALUES (DEFAULT, 'Vasay', 'Vasilkov', 'vasay@mail.ru', '89035744581', DEFAULT, DEFAULT);
-- Посмотрим на содержимое таблицы
SELECT * FROM users;

-- описание табилцы
DESCRIBE users;

-- скрипт создания таблицы
SHOW CREATE TABLE users;

-- 1:1 связь
CREATE TABLE profiles(
	user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
	gender ENUM ('f', 'm', 'x') NOT NULL,
	birthday DATE NOT NULL,
	photo_id INT UNSIGNED,
	city VARCHAR(130),
	country VARCHAR(130),
	FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Изменим тип колонки

ALTER TABLE profiles MODIFY COLUMN photo_id BIGINT UNSIGNED;

DESCRIBE profiles;

--  добавим колонку с номером паспорта

ALTER TABLE profiles ADD COLUMN passport_number VARCHAR(10);

-- переименование колонки

ALTER TABLE profiles RENAME COLUMN passport_number TO passport;

-- добавим индекс на колонку

ALTER TABLE profiles ADD KEY passport_idx (passport);

-- удалим индекс

ALTER TABLE profiles DROP INDEX passport_idx;

-- удалим колонку 

ALTER TABLE profiles DROP COLUMN passport;

-- Заполним таблицу, добавим профили уже для созданных Пети и Васи
INSERT INTO profiles VALUES (1, 'm', '1997-12-01', NULL, 'Moscow', 'Russia');
INSERT INTO profiles VALUES (2, 'm', '1982-11-11', NULL, 'Moscow', 'Russia');

SELECT * FROM profiles;

-- создадим таблицу сообщений пользователей
-- автор сообщения : сообщение
-- 1: М
-- 1 : 1

CREATE TABLE messages(
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
	to_user_id BIGINT UNSIGNED NOT NULL,
	txt TEXT NOT NULL,
	is_delivered BOOLEAN DEFAULT FALSE,
	created_at DATETIME NOT NULL DEFAULT NOW(),
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	INDEX messages_from_user_id_idx (from_user_id),
	INDEX messages_to_user_id_idx (to_user_id),
	CONSTRAINT fk_messages_from_user_id FOREIGN KEY (from_user_id) REFERENCES users (id),
	CONSTRAINT fk_messages_to_user_id FOREIGN KEY (to_user_id) REFERENCES users (id)
);

DESCRIBE messages;

-- добавим два сообщения пользователей
INSERT INTO messages VALUES (DEFAULT, 1, 2, 'Hi!', 1, DEFAULT, DEFAULT);
INSERT INTO messages VALUES (DEFAULT, 1, 2, 'Vasya!', 1, DEFAULT, DEFAULT);
INSERT INTO messages VALUES (DEFAULT, 2, 1, 'Hi, Petya!', 1, DEFAULT, DEFAULT);

SELECT * FROM messages;

CREATE TABLE friend_requests(
	from_user_id BIGINT UNSIGNED NOT NULL,
	to_user_id BIGINT UNSIGNED NOT NULL,
	accepted BOOLEAN DEFAULT FALSE,
	PRIMARY KEY(from_user_id, to_user_id),
	INDEX friend_requests_from_user_id_idx (from_user_id),
	INDEX friend_requests_to_user_id_idx (to_user_id),
	CONSTRAINT fk_friend_requests_from_user_id FOREIGN KEY (from_user_id) REFERENCES users (id),
	CONSTRAINT fk_friend_requests_to_user_id FOREIGN KEY (to_user_id) REFERENCES users (id)
);
-- Добавим запрос на дружбу
INSERT INTO friend_requests VALUES (1, 2, 1);

SELECT * FROM friend_requests;

CREATE TABLE communities(
	id SERIAL PRIMARY KEY,
	name VARCHAR(150) NOT NULL,
	description VARCHAR(255),
	admin_id BIGINT UNSIGNED NOT NULL,
	KEY (admin_id),
	FOREIGN KEY (admin_id) REFERENCES users(id)
);

INSERT INTO communities VALUES (DEFAULT, 'Number1', 'I am number one', 1);
INSERT INTO communities VALUES (DEFAULT, 'Number2', 'I am number two', 1);

SELECT * FROM communities;

-- пользователи : сообщества
-- М : 1 многие пользователи могут состоять в одном сообществе
-- 1 : М один пользователь может состоять во многих сообществах

CREATE TABLE communities_users(
	community_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(community_id, user_id),
	KEY (community_id),
	KEY (user_id),
	FOREIGN KEY (community_id) REFERENCES communities (id),
	FOREIGN KEY (user_id) REFERENCES users (id)
);

-- Добавим запись вида Вася в участеник сообщества Number1
INSERT INTO communities_users VALUES (1, 2, DEFAULT);

SELECT * FROM communities;

CREATE TABLE media_types(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL UNIQUE
);

-- Добавим типы в каталог 
INSERT INTO media_types VALUES (DEFAULT, 'изображение');
INSERT INTO media_types VALUES (DEFAULT, 'музыка');
INSERT INTO media_types VALUES (DEFAULT, 'документ');

SELECT * FROM media_types;

CREATE TABLE media (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	media_types_id INT UNSIGNED NOT NULL,
	file_name VARCHAR(255) COMMENT '/file/folder/img.png',
	file_size BIGINT UNSIGNED,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	KEY (media_types_id),
	KEY (user_id),
	FOREIGN KEY (media_types_id) REFERENCES media_types (id),
	FOREIGN KEY (user_id) REFERENCES users (id)
);

-- Добавим два изображения, которые добавил Петя

INSERT INTO media VALUES (DEFAULT, 1, 1, 'im.jpg', 100, DEFAULT);
INSERT INTO media VALUES (DEFAULT, 1, 1, 'im1.jpg', 78, DEFAULT);

-- Добавим документ, который добавил Вася

INSERT INTO media VALUES (DEFAULT, 2, 3, 'doc.docx', 1024, DEFAULT);

SELECT * FROM media;

-- добавим таблицу постов пользователей

CREATE TABLE posts(
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	txt TEXT,
	metadata JSON,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users (id)
);

-- добавим таблицу комментариев рользователей к постам

CREATE TABLE comments(
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
    post_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users (id),
    FOREIGN KEY(post_id) REFERENCES posts (id)
);

-- добавим таблицу лайков пользователей

CREATE TABLE likes(
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_post_id BIGINT UNSIGNED NOT NULL,
	to_user_id BIGINT UNSIGNED NOT NULL,
	to_media_id BIGINT UNSIGNED NOT NULL,
	to_comment_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY(from_user_id) REFERENCES users (id),
    FOREIGN KEY(to_post_id) REFERENCES posts (id),
    FOREIGN KEY(to_user_id) REFERENCES users (id),
    FOREIGN KEY(to_media_id) REFERENCES media (id),
    FOREIGN KEY(to_comment_id) REFERENCES comments (id),
    INDEX like_to_media_idx (from_user_id, to_media_id),
    INDEX like_post_idx (from_user_id, to_post_id),
    INDEX like_user_idx (from_user_id, to_user_id),
    INDEX like_comment_idx (from_user_id, to_comment_id)
);


/* Модифицируем базу */

-- совершенситвуем таблицу дружбы
-- добавляем ограничение - отправитель запроса на дружбу не может быть одновременно получателем

ALTER TABLE friend_requests
ADD CONSTRAINT sender_not_reciever_check
CHECK (from_user_id != to_user_id);

SELECT * FROM friend_requests;

-- добавляем ошраничение, что номер телефона должен состоять из 11 символов и только из цифр

ALTER TABLE users
ADD CONSTRAINT phone_check
CHECK (REGEXP_LIKE(phone, '^[0-9]{11}$')); -- регулярное выражение для проверки номера

-- делаем внешнгий ключ на медиа

ALTER TABLE profiles
ADD CONSTRAINT fk_profiles_media
FOREIGN KEY (photo_id) REFERENCES media (id);

/*
 * C -Create = INSERT
 * R - Read = SELECT
 * U - Update = UPDATE
 * D - Delete - DELETE
 */

-- добавляем пользователя
INSERT INTO users (id, first_name, last_name, email, phone, password_hash)
VALUES (DEFAULT, 'Alex', 'Stepanov', 'alex@mail.com', '89212356566', 'aaa');

SELECT * FROM users;

-- не указываем значения по умолчанию
INSERT users (first_name, last_name, email, phone)
VALUES ('Lena', 'Stepanova', 'lena@mail.com', '89213546568');

-- не указываем названия колонок
INSERT users
VALUES (DEFAULT, 'Chris', 'Ivanov', 'chris@mail.com', '89213546560', DEFAULT, DEFAULT);

-- явно задаем id
INSERT INTO users (id, first_name, last_name, email, phone)
VALUES (55, 'Jane', 'Kvanov', 'jane@mail.com', '89293546560');

-- пробуем добавить id меньше текущего
INSERT INTO users (id, first_name, last_name, email, phone) VALUES
(45, 'Jane', 'Night', 'jane_n@mail.com', '89293946560');

-- добавляем нескольких пользователей
INSERT INTO users (first_name, last_name, email, phone)
VALUES ('Igor', 'Petrov', 'igor@mail.com', '89213549560'),
		('Oksana', 'Petrova', 'oksana@mail.com', '89213549561');

SELECT * FROM users;

-- добавляем через SET
INSERT INTO users
SET first_name = 'Iren',
	last_name = 'Sidorova',
	email = 'iren@mail.com',
	phone = '89213541560';

-- выбираем константы
SELECT 'hello';

SELECT 1+10;

-- выбираем все поля пользователей
SELECT * FROM users;

-- выбираем только имена users

SELECT first_name FROM users;

-- выбираем только уникальные имена

SELECT DISTINCT first_name FROM users;

SELECT * FROM users WHERE last_name = 'Petrov'; -- условие WHERE

SELECT * FROM users WHERE id <= 10;

SELECT * FROM users WHERE id BETWEEN 3 AND 7;

-- выбираем пользователей, у которых нет пароля
SELECT * FROM users WHERE password_hash IS NULL;

-- выбираем пользователей, у которых есть пароль
SELECT * FROM users WHERE password_hash IS NOT NULL;

-- выбираем четырех пользователей
SELECT * FROM users Limit 4;

-- выбираем четырех пользователей
SELECT * FROM users ORDER BY id DESC Limit 4;

-- выбираем четвертого пользователя по порядку

SELECT * FROM users ORDER BY id LIMIT 1 OFFSET 3;

SELECT * FROM users ORDER BY id LIMIT 3,1; -- то же самое, только короче запись

INSERT INTO messages (from_user_id, to_user_id, txt)
VALUES (45, 55, 'Hi!');

INSERT INTO messages (from_user_id, to_user_id, txt)
VALUES (45, 55, 'I hate you!');

SELECT * FROM messages;

-- меняем статус сообщения на "доставлено"

UPDATE messages
SET is_delivered = TRUE;

-- меняем текст сообщения

UPDATE messages
SET txt = 'I love you'
WHERE id = 5;

-- удаляем пользователя с фамилией Степанов

DELETE FROM users WHERE last_name = 'Stepanov';

SELECT * FROM users;

-- удаляем все строки из сообщений
DELETE FROM messages;

SELECT * FROM messages;

-- удаляем все строки из сообщений и создаем ее заново, главное чтобы не было внешних ключей
TRUNCATE TABLE messages;




