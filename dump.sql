-- Adminer 4.7.6 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;

DROP TABLE IF EXISTS `allergen`;
CREATE TABLE `allergen` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


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


DROP TABLE IF EXISTS `component`;
CREATE TABLE `component` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


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


DROP TABLE IF EXISTS `feces`;
CREATE TABLE `feces` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


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


DROP TABLE IF EXISTS `registered_meal`;
CREATE TABLE `registered_meal` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` int NOT NULL,
  `datetime` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  CONSTRAINT `registered_meal_ibfk_1` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


DROP TABLE IF EXISTS `registered_supplement`;
CREATE TABLE `registered_supplement` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` int NOT NULL,
  `datetime` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  CONSTRAINT `registered_supplement_ibfk_1` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


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


DROP TABLE IF EXISTS `symptom`;
CREATE TABLE `symptom` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(250) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `password` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `googleid` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


DROP VIEW IF EXISTS `v_user_anything`;
CREATE TABLE `v_user_anything` (`user` int, `date` date, `count(*)` bigint);


DROP VIEW IF EXISTS `v_user_symptoms`;
CREATE TABLE `v_user_symptoms` (`reg_id` int, `user` int, `email` varchar(100), `datetime` datetime, `s_id` int, `s_name` varchar(100));


DROP TABLE IF EXISTS `v_user_anything`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_user_anything` AS select `query`.`user` AS `user`,`query`.`date` AS `date`,count(0) AS `count(*)` from (select `sy`.`id` AS `id`,`sy`.`user` AS `user`,cast(`sy`.`datetime` as date) AS `date`,'sy' AS `type` from `registered_symptom` `sy` union select `sy`.`id` AS `id`,`sy`.`user` AS `user`,cast(`sy`.`datetime` as date) AS `date`,'fe' AS `type` from `registered_feces` `sy` union select `sy`.`id` AS `id`,`sy`.`user` AS `user`,cast(`sy`.`datetime` as date) AS `date`,'me' AS `type` from `registered_meal` `sy` union select `sy`.`id` AS `id`,`sy`.`user` AS `user`,cast(`sy`.`datetime` as date) AS `date`,'su' AS `type` from `registered_supplement` `sy`) `query` group by `query`.`user`,`query`.`date`;

DROP TABLE IF EXISTS `v_user_symptoms`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_user_symptoms` AS select `r_s`.`id` AS `reg_id`,`u`.`id` AS `user`,`u`.`email` AS `email`,`r_s`.`datetime` AS `datetime`,`s`.`id` AS `s_id`,`s`.`name` AS `s_name` from ((`user` `u` join `registered_symptom` `r_s` on((`r_s`.`user` = `u`.`id`))) join `symptom` `s` on((`s`.`id` = `r_s`.`symptom`)));

-- 2023-01-23 16:43:05
