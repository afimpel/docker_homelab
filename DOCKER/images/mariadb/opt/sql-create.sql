CREATE SCHEMA IF NOT EXISTS `DATABASE` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'DATABASE -- USERNAME';
GRANT ALL PRIVILEGES ON `USERNAME\_%`.* TO `USERNAME`@`%` IDENTIFIED BY 'MARIADB_ROOT_PASSWORD' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON `USERNAME\_%`.* TO `adminer`@`%` WITH GRANT OPTION;
FLUSH PRIVILEGES;
