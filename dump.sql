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


DROP VIEW IF EXISTS `v_all_entries`;
CREATE TABLE `v_all_entries` (`user` int, `date` date, `time` time, `id` int, `table` varchar(21), `type-en` varchar(10), `type-es` varchar(10), `value` mediumtext);


DROP VIEW IF EXISTS `v_user_anything`;
CREATE TABLE `v_user_anything` (`user` int, `date` date, `count(*)` bigint);


DROP VIEW IF EXISTS `v_user_feces`;
CREATE TABLE `v_user_feces` (`user` int, `datetime` datetime, `id` int, `value` varchar(100));


DROP VIEW IF EXISTS `v_user_meals`;
CREATE TABLE `v_user_meals` (`user` int, `datetime` datetime, `id` int, `value` text);


DROP VIEW IF EXISTS `v_user_supplement`;
CREATE TABLE `v_user_supplement` (`user` int, `datetime` datetime, `id` int, `value` text);


DROP VIEW IF EXISTS `v_user_symptoms`;
CREATE TABLE `v_user_symptoms` (`user` int, `datetime` datetime, `id` int, `value` varchar(100));


DROP TABLE IF EXISTS `v_all_entries`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_all_entries` AS select `query`.`user` AS `user`,`query`.`date` AS `date`,`query`.`time` AS `time`,`query`.`id` AS `id`,`query`.`table` AS `table`,`query`.`type-en` AS `type-en`,`query`.`type-es` AS `type-es`,`query`.`value` AS `value` from (select `sy`.`id` AS `id`,`sy`.`user` AS `user`,`sy`.`value` AS `value`,cast(`sy`.`datetime` as date) AS `date`,cast(`sy`.`datetime` as time) AS `time`,'registered_symptom' AS `table`,'Symptom' AS `type-en`,'Sintoma' AS `type-es` from `v_user_symptoms` `sy` union select `sy`.`id` AS `id`,`sy`.`user` AS `user`,`sy`.`value` AS `value`,cast(`sy`.`datetime` as date) AS `date`,cast(`sy`.`datetime` as time) AS `time`,'registered_feces' AS `table`,'Feces' AS `type-en`,'Heces' AS `type-es` from `v_user_feces` `sy` union select `sy`.`id` AS `id`,`sy`.`user` AS `user`,`sy`.`value` AS `value`,cast(`sy`.`datetime` as date) AS `date`,cast(`sy`.`datetime` as time) AS `time`,'registered_meal' AS `table`,'Meal' AS `type-en`,'Comida' AS `type-es` from `v_user_meals` `sy` union select `sy`.`id` AS `id`,`sy`.`user` AS `user`,`sy`.`value` AS `value`,cast(`sy`.`datetime` as date) AS `date`,cast(`sy`.`datetime` as time) AS `time`,'registered_supplement' AS `table`,'Supplement' AS `type-en`,'Suplemento' AS `type-es` from `v_user_supplement` `sy`) `query`;

DROP TABLE IF EXISTS `v_user_anything`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_user_anything` AS select `query`.`user` AS `user`,`query`.`date` AS `date`,count(0) AS `count(*)` from (select `sy`.`id` AS `id`,`sy`.`user` AS `user`,cast(`sy`.`datetime` as date) AS `date`,'sy' AS `type` from `registered_symptom` `sy` union select `sy`.`id` AS `id`,`sy`.`user` AS `user`,cast(`sy`.`datetime` as date) AS `date`,'fe' AS `type` from `registered_feces` `sy` union select `sy`.`id` AS `id`,`sy`.`user` AS `user`,cast(`sy`.`datetime` as date) AS `date`,'me' AS `type` from `registered_meal` `sy` union select `sy`.`id` AS `id`,`sy`.`user` AS `user`,cast(`sy`.`datetime` as date) AS `date`,'su' AS `type` from `registered_supplement` `sy`) `query` group by `query`.`user`,`query`.`date`;

DROP TABLE IF EXISTS `v_user_feces`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_user_feces` AS select `r_f`.`user` AS `user`,`r_f`.`datetime` AS `datetime`,`r_f`.`id` AS `id`,`f`.`name` AS `value` from (`registered_feces` `r_f` join `feces` `f` on((`r_f`.`feces` = `f`.`id`)));

DROP TABLE IF EXISTS `v_user_meals`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_user_meals` AS select `r_m`.`user` AS `user`,`r_m`.`datetime` AS `datetime`,`a_m`.`meal` AS `id`,group_concat(`a`.`name` separator ',') AS `value` from ((`registered_meal` `r_m` join `allergen_in_meal` `a_m` on((`r_m`.`id` = `a_m`.`meal`))) join `allergen` `a` on((`a_m`.`allergen` = `a`.`id`))) group by `a_m`.`meal`;

DROP TABLE IF EXISTS `v_user_supplement`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_user_supplement` AS select `r_s`.`user` AS `user`,`r_s`.`datetime` AS `datetime`,`c_s`.`supplement` AS `id`,group_concat(`c`.`name` separator ',') AS `value` from ((`registered_supplement` `r_s` join `component_in_supplement` `c_s` on((`r_s`.`id` = `c_s`.`supplement`))) join `component` `c` on((`c_s`.`component` = `c`.`id`))) group by `c_s`.`supplement`;

DROP TABLE IF EXISTS `v_user_symptoms`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_user_symptoms` AS select `u`.`id` AS `user`,`r_s`.`datetime` AS `datetime`,`r_s`.`id` AS `id`,`s`.`name` AS `value` from ((`user` `u` join `registered_symptom` `r_s` on((`r_s`.`user` = `u`.`id`))) join `symptom` `s` on((`s`.`id` = `r_s`.`symptom`)));

-- 2023-03-10 20:59:38