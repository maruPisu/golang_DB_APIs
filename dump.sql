-- Adminer 4.7.6 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `allergen`;
CREATE TABLE `allergen` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `allergen` (`id`, `name`, `description`) VALUES
(1,	'Dairy',	''),
(2,	'Eggs',	''),
(3,	'Fish',	'e.g., bass, flounder, cod'),
(4,	'Crustacean shellfish',	'e.g., crab, lobster, shrimp'),
(5,	'Tree nuts',	'e.g., almonds, walnuts, pecans'),
(6,	'Peanuts',	''),
(7,	'Wheat',	''),
(8,	'Soybeans',	'');

DROP TABLE IF EXISTS `allergen_in_meal`;
CREATE TABLE `allergen_in_meal` (
  `id` int NOT NULL AUTO_INCREMENT,
  `meal` int NOT NULL,
  `allergen` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `meal` (`meal`),
  KEY `allergen` (`allergen`),
  CONSTRAINT `allergen_in_meal_ibfk_1` FOREIGN KEY (`meal`) REFERENCES `registered_meal` (`id`),
  CONSTRAINT `allergen_in_meal_ibfk_2` FOREIGN KEY (`allergen`) REFERENCES `allergen` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `allergen_in_meal` (`id`, `meal`, `allergen`) VALUES
(1,	1,	3);

DROP TABLE IF EXISTS `component`;
CREATE TABLE `component` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `component` (`id`, `name`, `description`) VALUES
(1,	'magnesium',	''),
(2,	'calcium',	''),
(3,	'vitamin D',	'');

DROP TABLE IF EXISTS `component_in_supplement`;
CREATE TABLE `component_in_supplement` (
  `id` int NOT NULL AUTO_INCREMENT,
  `supplement` int NOT NULL,
  `component` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `component` (`component`),
  KEY `supplement` (`supplement`),
  CONSTRAINT `component_in_supplement_ibfk_2` FOREIGN KEY (`component`) REFERENCES `component` (`id`),
  CONSTRAINT `component_in_supplement_ibfk_3` FOREIGN KEY (`supplement`) REFERENCES `registered_supplement` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `component_in_supplement` (`id`, `supplement`, `component`) VALUES
(2,	1,	3);

DROP TABLE IF EXISTS `feces`;
CREATE TABLE `feces` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `feces` (`id`, `name`, `description`) VALUES
(1,	'Type 1',	'Separate hard lumps, like nuts (difficult to pass)'),
(2,	'Type 2',	'Sausage-shaped, but lumpy'),
(3,	'Type 3',	'Like a sausage but with cracks on its surface'),
(4,	'Type 4',	'Like a sausage or snake, smooth and soft (average stool)'),
(5,	'Type 5',	'Soft blobs with clear cut edges'),
(6,	'Type 6',	'Fluffy pieces with ragged edges, a mushy stool (diarrhoea)'),
(7,	'Type 7',	'Watery, no solid pieces, entirely liquid (diarrhoea)');

DROP TABLE IF EXISTS `registered_feces`;
CREATE TABLE `registered_feces` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` int NOT NULL,
  `feces` int NOT NULL,
  `datetime` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  KEY `feces` (`feces`),
  CONSTRAINT `registered_feces_ibfk_1` FOREIGN KEY (`user`) REFERENCES `user` (`id`),
  CONSTRAINT `registered_feces_ibfk_2` FOREIGN KEY (`feces`) REFERENCES `feces` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `registered_feces` (`id`, `user`, `feces`, `datetime`) VALUES
(1,	1,	3,	'2006-01-02 15:04:05');

DROP TABLE IF EXISTS `registered_meal`;
CREATE TABLE `registered_meal` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` int NOT NULL,
  `datetime` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  CONSTRAINT `registered_meal_ibfk_1` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `registered_meal` (`id`, `user`, `datetime`) VALUES
(1,	1,	'2006-01-02 15:04:05');

DROP TABLE IF EXISTS `registered_supplement`;
CREATE TABLE `registered_supplement` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` int NOT NULL,
  `datetime` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  CONSTRAINT `registered_supplement_ibfk_1` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `registered_supplement` (`id`, `user`, `datetime`) VALUES
(1,	1,	'2006-01-02 15:04:05'),
(2,	1,	'2023-01-23 17:29:39');

DROP TABLE IF EXISTS `registered_symptom`;
CREATE TABLE `registered_symptom` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` int NOT NULL,
  `symptom` int NOT NULL,
  `datetime` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  KEY `symptom` (`symptom`),
  CONSTRAINT `registered_symptom_ibfk_1` FOREIGN KEY (`user`) REFERENCES `user` (`id`),
  CONSTRAINT `registered_symptom_ibfk_2` FOREIGN KEY (`symptom`) REFERENCES `symptom` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `registered_symptom` (`id`, `user`, `symptom`, `datetime`) VALUES
(1,	1,	2,	'2022-08-22 09:03:03'),
(2,	1,	1,	'2022-08-27 12:50:03'),
(3,	1,	3,	'2022-08-27 18:43:00'),
(4,	1,	4,	'2022-08-26 21:30:00'),
(5,	1,	3,	'2022-08-28 11:18:00'),
(6,	1,	1,	'2022-08-28 11:19:00'),
(7,	1,	1,	'2022-08-28 11:21:00'),
(8,	1,	3,	'2022-08-12 21:00:00'),
(9,	1,	2,	'2022-08-18 17:01:00'),
(10,	1,	1,	'2022-08-19 06:30:00'),
(11,	1,	1,	'2022-07-15 20:40:00'),
(12,	1,	3,	'2022-08-10 23:06:00'),
(13,	1,	2,	'2022-08-27 20:30:00'),
(14,	1,	2,	'2022-08-19 20:30:00'),
(15,	1,	4,	'2022-08-10 19:19:00'),
(16,	1,	1,	'2022-08-17 19:19:00'),
(17,	1,	4,	'2022-08-28 22:30:00'),
(18,	1,	4,	'2022-09-12 10:30:00'),
(19,	1,	3,	'2022-10-28 16:39:00'),
(20,	1,	3,	'2006-01-02 15:04:05'),
(21,	1,	1,	'2023-01-17 18:29:00'),
(22,	3,	3,	'2023-01-17 16:32:00'),
(23,	3,	4,	'2023-01-16 20:10:00'),
(24,	4,	2,	'2023-01-15 20:55:00'),
(25,	3,	2,	'2023-01-17 10:00:00'),
(26,	7,	2,	'2023-01-16 22:27:00'),
(27,	3,	3,	'2023-01-25 11:25:00'),
(28,	7,	3,	'2023-01-21 09:27:00');

DROP TABLE IF EXISTS `symptom`;
CREATE TABLE `symptom` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(250) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `symptom` (`id`, `name`, `description`) VALUES
(1,	'dry cough',	'dry cough'),
(2,	'productive cough',	'wet cough'),
(3,	'headache',	'head pain'),
(4,	'tiredness',	'feeling tired');

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `password` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `googleid` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `user` (`id`, `email`, `name`, `password`, `googleid`) VALUES
(1,	'pisu.maru@gmail.com',	'124',	'asdklj',	''),
(3,	'gigamaru@gmail.com',	'Maru',	NULL,	'103406887390171757143'),
(4,	'mynigo@ucm.es',	'María del Carmen Ynigo Rivera',	NULL,	'109138256151483633043'),
(6,	'pisu.marh@gmail.com',	'Marui3',	'vvio',	NULL),
(7,	'abc@gmail.com',	'provo',	'password',	NULL);

DROP VIEW IF EXISTS `v_user_anything`;
CREATE TABLE `v_user_anything` (`user` int, `date` date, `count(*)` bigint);


DROP VIEW IF EXISTS `v_user_symptoms`;
CREATE TABLE `v_user_symptoms` (`reg_id` int, `user` int, `email` varchar(100), `datetime` datetime, `s_id` int, `s_name` varchar(100));


DROP TABLE IF EXISTS `v_user_anything`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_user_anything` AS select `query`.`user` AS `user`,`query`.`date` AS `date`,count(0) AS `count(*)` from (select `sy`.`id` AS `id`,`sy`.`user` AS `user`,cast(`sy`.`datetime` as date) AS `date`,'sy' AS `type` from `registered_symptom` `sy` union select `sy`.`id` AS `id`,`sy`.`user` AS `user`,cast(`sy`.`datetime` as date) AS `date`,'fe' AS `type` from `registered_feces` `sy` union select `sy`.`id` AS `id`,`sy`.`user` AS `user`,cast(`sy`.`datetime` as date) AS `date`,'me' AS `type` from `registered_meal` `sy` union select `sy`.`id` AS `id`,`sy`.`user` AS `user`,cast(`sy`.`datetime` as date) AS `date`,'su' AS `type` from `registered_supplement` `sy`) `query` group by `query`.`user`,`query`.`date`;

DROP TABLE IF EXISTS `v_user_symptoms`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_user_symptoms` AS select `r_s`.`id` AS `reg_id`,`u`.`id` AS `user`,`u`.`email` AS `email`,`r_s`.`datetime` AS `datetime`,`s`.`id` AS `s_id`,`s`.`name` AS `s_name` from ((`user` `u` join `registered_symptom` `r_s` on((`r_s`.`user` = `u`.`id`))) join `symptom` `s` on((`s`.`id` = `r_s`.`symptom`)));

-- 2023-01-23 16:41:33
