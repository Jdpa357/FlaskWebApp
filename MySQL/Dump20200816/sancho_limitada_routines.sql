-- MySQL dump 10.13  Distrib 8.0.21, for Win64 (x86_64)
--
-- Host: localhost    Database: sancho_limitada
-- ------------------------------------------------------
-- Server version	8.0.21

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'sancho_limitada'
--
/*!50003 DROP PROCEDURE IF EXISTS `deactivate_product` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deactivate_product`(
IN p_product_name VARCHAR(45)
)
BEGIN
	if ( select exists (select 1 from products where product_name = p_product_name) ) THEN
		UPDATE products
        SET
        product_status = 0 WHERE product_name = p_product_name;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deactivate_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deactivate_user`(
IN p_name VARCHAR(45)
)
BEGIN
	if ( select exists (select 1 from users where user_name = p_name) ) THEN 
    DELETE FROM users
    WHERE user_name = p_name;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sl_createbilling` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sl_createbilling`(
IN p_billing_code INT,
IN p_billing_user VARCHAR(45),
IN p_billing_products VARCHAR(100),
IN p_billing_date VARCHAR(100),
IN p_products_quantity INT,
IN p_total_value BIGINT,
IN p_payment_method INT
)
BEGIN
	if ( select exists (select 1 from billing where billing_code = p_billing_code) ) THEN
		select 'Billing allready exists!';
	ELSE
		insert into billing
        (
        billing_code,
        billing_user,
        billing_products,
        billing_date,
        products_quantity,
        billing_total_value,
        billing_payment_method
        )
        values
        (
            p_billing_code,
            p_billing_user,
			p_billing_products,
            p_billing_date,
            p_products_quantity,
            p_total_value,
            p_payment_method
        );
	END if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sl_createproduct` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sl_createproduct`(
IN p_product_name VARCHAR(45),
IN p_product_code INT,
IN p_category INT,
IN p_price INT,
IN p_stored_quantity INT,
IN p_product_status INT,
IN p_product_image VARCHAR(100)
)
BEGIN
	if ( select exists (select 1 from products where product_name = p_product_name) ) THEN
		select 'Product allready exists!';
	ELSE
		insert into products
        (
        product_name,
        product_code,
        category,
        price,
        stored_quantity,
        product_status,
        product_image
        )
        values
        (
			p_product_name,
            p_product_code,
			p_category,
            p_price,
            p_stored_quantity,
            p_product_status,
            p_product_image
        );
	END if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sl_createuser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sl_createuser`(
IN p_idtype INT,
IN p_number INT,
IN p_name VARCHAR(45),
IN p_lastname VARCHAR(45),
IN p_email VARCHAR(100),
IN p_password VARCHAR(45),
IN p_address VARCHAR(45),
IN p_phone VARCHAR(45),
IN p_picture VARCHAR(100),
IN p_date VARCHAR(100)
)
BEGIN
	if ( select exists (select 1 from users where user_name = p_name) ) THEN
		select 'User allready exists!';
	ELSE
		insert into users
        (
        id_type,
        id_number,
        user_name,
        user_lastname,
        user_email,
        user_password,
        user_address,
        user_phone,
        user_picture,
        registry_date
        )
        values
        (
            p_idtype,
            p_number,
			p_name,
            p_lastname,
            p_email,
            p_password,
            p_address,
            p_phone,
            p_picture,
            p_date
        );
	END if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_billing` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_billing`(
IN p_billind_id INT,
IN p_billing_code INT,
IN p_billing_user VARCHAR(45),
IN p_billing_products VARCHAR(100),
IN p_billing_date VARCHAR(100),
IN p_products_quantity INT,
IN p_total_value BIGINT,
IN p_payment_method INT
)
BEGIN
	if ( select exists (select 1 from billing where billing_code = p_billing_code) ) THEN
		UPDATE users
        SET
        billing_code = p_billing_code WHERE billing_id = p_billing_id;
        UPDATE users
        SET
        billing_user = p_billing_user WHERE billing_id = p_billing_id;
        UPDATE users
        SET
        billing_products = p_billing_products WHERE billing_id = p_billing_id;
        UPDATE users
        SET
        billing_date = p_billing_date WHERE billing_id = p_billing_id;
        UPDATE users
        SET
        products_quantity = p_products_quantity WHERE billing_id = p_billing_id;
        UPDATE users
        SET
        total_value = p_total_value WHERE billing_id = p_billing_id;
        UPDATE users
        SET
        payment_method = p_payment_method WHERE billing_id = p_billing_id;
	END if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-08-16 11:51:40
