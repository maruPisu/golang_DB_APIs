-- Adminer 4.7.6 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;

DROP TABLE IF EXISTS `allergen`;
CREATE TABLE `allergen` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


DROP TABLE IF EXISTS `allergen_en`;
CREATE TABLE `allergen_en` (
  `allergen` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  KEY `allergen` (`allergen`),
  CONSTRAINT `allergen_en_ibfk_1` FOREIGN KEY (`allergen`) REFERENCES `allergen` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


DROP TABLE IF EXISTS `allergen_es`;
CREATE TABLE `allergen_es` (
  `allergen` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  KEY `allergen` (`allergen`),
  CONSTRAINT `allergen_es_ibfk_1` FOREIGN KEY (`allergen`) REFERENCES `allergen` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


DROP TABLE IF EXISTS `allergen_in_meal`;
CREATE TABLE `allergen_in_meal` (
  `id` int NOT NULL AUTO_INCREMENT,
  `meal` int NOT NULL,
  `allergen` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `allergen` (`allergen`),
  KEY `meal` (`meal`),
  CONSTRAINT `allergen_in_meal_ibfk_2` FOREIGN KEY (`allergen`) REFERENCES `allergen` (`id`),
  CONSTRAINT `allergen_in_meal_ibfk_3` FOREIGN KEY (`meal`) REFERENCES `registered_meal` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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
  KEY `supplement` (`supplement`),
  KEY `component` (`component`),
  CONSTRAINT `component_in_supplement_ibfk_5` FOREIGN KEY (`supplement`) REFERENCES `registered_supplement` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `component_in_supplement_ibfk_6` FOREIGN KEY (`component`) REFERENCES `component` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


DROP TABLE IF EXISTS `feces`;
CREATE TABLE `feces` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


DROP TABLE IF EXISTS `feces_en`;
CREATE TABLE `feces_en` (
  `feces` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  KEY `feces` (`feces`),
  CONSTRAINT `feces_en_ibfk_1` FOREIGN KEY (`feces`) REFERENCES `feces` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


DROP TABLE IF EXISTS `feces_es`;
CREATE TABLE `feces_es` (
  `feces` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  KEY `feces` (`feces`),
  CONSTRAINT `feces_es_ibfk_1` FOREIGN KEY (`feces`) REFERENCES `feces` (`id`)
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


DROP TABLE IF EXISTS `symptom_en`;
CREATE TABLE `symptom_en` (
  `symptom` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  KEY `symptom` (`symptom`),
  CONSTRAINT `symptom_en_ibfk_1` FOREIGN KEY (`symptom`) REFERENCES `symptom` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


DROP TABLE IF EXISTS `symptom_es`;
CREATE TABLE `symptom_es` (
  `symptom` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  KEY `symptom` (`symptom`),
  CONSTRAINT `symptom_es_ibfk_1` FOREIGN KEY (`symptom`) REFERENCES `symptom` (`id`)
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
CREATE TABLE `v_all_entries` (`user` int, `date` date, `time` time, `id` int, `table` varchar(21), `type_en` varchar(10), `type_es` varchar(10), `value_en` mediumtext, `value_es` mediumtext);


DROP VIEW IF EXISTS `v_user_anything`;
CREATE TABLE `v_user_anything` (`user` int, `date` date, `count(*)` bigint);


DROP VIEW IF EXISTS `v_user_feces`;
CREATE TABLE `v_user_feces` (`user` int, `datetime` datetime, `id` int, `value_en` varchar(100), `value_es` varchar(100));


DROP VIEW IF EXISTS `v_user_meals`;
CREATE TABLE `v_user_meals` (`user` int, `datetime` datetime, `id` int, `value_en` text, `value_es` text);


DROP VIEW IF EXISTS `v_user_supplement`;
CREATE TABLE `v_user_supplement` (`user` int, `datetime` datetime, `id` int, `value` text);


DROP VIEW IF EXISTS `v_user_symptoms`;
CREATE TABLE `v_user_symptoms` (`user` int, `datetime` datetime, `id` int, `value_en` varchar(100), `value_es` varchar(100));


DROP TABLE IF EXISTS `v_all_entries`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_all_entries` AS select `query`.`user` AS `user`,`query`.`date` AS `date`,`query`.`time` AS `time`,`query`.`id` AS `id`,`query`.`table` AS `table`,`query`.`type_en` AS `type_en`,`query`.`type_es` AS `type_es`,`query`.`value_en` AS `value_en`,`query`.`value_es` AS `value_es` from (select `sy`.`id` AS `id`,`sy`.`user` AS `user`,`sy`.`value_en` AS `value_en`,`sy`.`value_es` AS `value_es`,cast(`sy`.`datetime` as date) AS `date`,cast(`sy`.`datetime` as time) AS `time`,'registered_symptom' AS `table`,'Symptom' AS `type_en`,'Sintoma' AS `type_es` from `v_user_symptoms` `sy` union select `sy`.`id` AS `id`,`sy`.`user` AS `user`,`sy`.`value_en` AS `value_en`,`sy`.`value_es` AS `value_es`,cast(`sy`.`datetime` as date) AS `date`,cast(`sy`.`datetime` as time) AS `time`,'registered_feces' AS `table`,'Feces' AS `type_en`,'Heces' AS `type_es` from `v_user_feces` `sy` union select `sy`.`id` AS `id`,`sy`.`user` AS `user`,`sy`.`value_en` AS `value_en`,`sy`.`value_es` AS `value_es`,cast(`sy`.`datetime` as date) AS `date`,cast(`sy`.`datetime` as time) AS `time`,'registered_meal' AS `table`,'Meal' AS `type_en`,'Comida' AS `type_es` from `v_user_meals` `sy` union select `sy`.`id` AS `id`,`sy`.`user` AS `user`,`sy`.`value` AS `value_en`,'' AS `value_es`,cast(`sy`.`datetime` as date) AS `date`,cast(`sy`.`datetime` as time) AS `time`,'registered_supplement' AS `table`,'Supplement' AS `type_en`,'Suplemento' AS `type_es` from `v_user_supplement` `sy`) `query` order by `query`.`date`,`query`.`time`;

DROP TABLE IF EXISTS `v_user_anything`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_user_anything` AS select `query`.`user` AS `user`,`query`.`date` AS `date`,count(0) AS `count(*)` from (select `sy`.`id` AS `id`,`sy`.`user` AS `user`,cast(`sy`.`datetime` as date) AS `date`,'sy' AS `type` from `registered_symptom` `sy` union select `sy`.`id` AS `id`,`sy`.`user` AS `user`,cast(`sy`.`datetime` as date) AS `date`,'fe' AS `type` from `registered_feces` `sy` union select `sy`.`id` AS `id`,`sy`.`user` AS `user`,cast(`sy`.`datetime` as date) AS `date`,'me' AS `type` from `registered_meal` `sy` union select `sy`.`id` AS `id`,`sy`.`user` AS `user`,cast(`sy`.`datetime` as date) AS `date`,'su' AS `type` from `registered_supplement` `sy`) `query` group by `query`.`user`,`query`.`date`;

DROP TABLE IF EXISTS `v_user_feces`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_user_feces` AS select `r_f`.`user` AS `user`,`r_f`.`datetime` AS `datetime`,`r_f`.`id` AS `id`,`en`.`name` AS `value_en`,`es`.`name` AS `value_es` from (((`registered_feces` `r_f` join `feces` `f` on((`r_f`.`feces` = `f`.`id`))) join `feces_en` `en` on((`en`.`feces` = `f`.`id`))) join `feces_es` `es` on((`es`.`feces` = `f`.`id`)));

DROP TABLE IF EXISTS `v_user_meals`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_user_meals` AS select `r_m`.`user` AS `user`,`r_m`.`datetime` AS `datetime`,`a_m`.`meal` AS `id`,group_concat(`en`.`name` separator ',') AS `value_en`,group_concat(`es`.`name` separator ',') AS `value_es` from ((((`registered_meal` `r_m` join `allergen_in_meal` `a_m` on((`r_m`.`id` = `a_m`.`meal`))) join `allergen` `a` on((`a_m`.`allergen` = `a`.`id`))) join `allergen_en` `en` on((`a`.`id` = `en`.`allergen`))) join `allergen_es` `es` on((`a`.`id` = `es`.`allergen`))) group by `a_m`.`meal`;

DROP TABLE IF EXISTS `v_user_supplement`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_user_supplement` AS select `r_s`.`user` AS `user`,`r_s`.`datetime` AS `datetime`,`c_s`.`supplement` AS `id`,group_concat(`c`.`name` separator ',') AS `value` from ((`registered_supplement` `r_s` join `component_in_supplement` `c_s` on((`r_s`.`id` = `c_s`.`supplement`))) join `component` `c` on((`c_s`.`component` = `c`.`id`))) group by `c_s`.`supplement`;

DROP TABLE IF EXISTS `v_user_symptoms`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_user_symptoms` AS select `u`.`id` AS `user`,`r_s`.`datetime` AS `datetime`,`r_s`.`id` AS `id`,`en`.`name` AS `value_en`,`es`.`name` AS `value_es` from ((((`user` `u` join `registered_symptom` `r_s` on((`r_s`.`user` = `u`.`id`))) join `symptom` `s` on((`s`.`id` = `r_s`.`symptom`))) join `symptom_en` `en` on((`s`.`id` = `en`.`symptom`))) join `symptom_es` `es` on((`s`.`id` = `es`.`symptom`)));

-- 2023-03-22 21:15:13