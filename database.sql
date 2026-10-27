-- MySQL dump 10.13  Distrib 8.0.30, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: politica
-- ------------------------------------------------------
-- Server version	8.0.30

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `politica`
--

/*!40000 DROP DATABASE IF EXISTS `politica`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `politica` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `politica`;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
INSERT INTO `cache` VALUES ('laravel-cache-5c785c036466adea360111aa28563bfd556b5fba','i:1;',1787513580),('laravel-cache-5c785c036466adea360111aa28563bfd556b5fba:timer','i:1787513580;',1787513580);
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `debates`
--

DROP TABLE IF EXISTS `debates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `debates` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `category` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `author_id` bigint unsigned NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'open',
  `image_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_credit` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `video_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `video_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sources` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `debates_author_id_foreign` (`author_id`),
  KEY `debates_category_index` (`category`),
  KEY `debates_status_created_at_index` (`status`,`created_at`),
  CONSTRAINT `debates_author_id_foreign` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `debates`
--

LOCK TABLES `debates` WRITE;
/*!40000 ALTER TABLE `debates` DISABLE KEYS */;
INSERT INTO `debates` VALUES (1,'Sobresueldos de 5.000 dólares: ¿se compran votos en la Asamblea?','En agosto de 2026, Nadia Beller denunció presuntos pagos mensuales de 5.000 dólares a legisladores de Libre y Unidad a cambio de aprobar normas y frenar censuras. Libre pidió levantar el secreto bancario; el PDC habló de comisión investigadora. Hasta ahora no hay sentencia: hay una lista, un remezón en la ALP y una pregunta cruda. ¿La Asamblea se fiscaliza o se alquila?','politica',1,'open','debates/images/alp-legislativo.jpg','Palacio Legislativo, Plaza Murillo, La Paz. Wikimedia Commons / Yolipy (CC BY-SA 4.0).',NULL,NULL,'[{\"url\": \"https://www.vision360.bo/noticias/2026/08/20/63634-denuncia-de-sobresueldos-causa-un-remezon-en-la-alp-y-legisladores-demandan-una-investigacion-a-fondo\", \"name\": \"Visión 360 — denuncia de sobresueldos en la ALP\"}, {\"url\": \"https://eju.tv/2026/08/sobresueldos-libre-pide-a-legisladores-y-autoridades-del-gobierno-renunciar-al-secreto-bancario-y-pdc-investigar-pagos/\", \"name\": \"eju.tv — Libre pide levantar el secreto bancario\"}, {\"url\": \"https://exitonoticias.com.bo/tras-ser-mencionados-en-la-lista-de-beller-diputados-exigen-pruebas-y-solicitan-levantar-el-secreto-bancario/400908/\", \"name\": \"Éxito Noticias — lista de Beller y pedido de pruebas\"}]','2026-08-12 14:31:22','2026-08-22 07:31:22'),(2,'Diésel a 18 bolivianos para industrias: ¿sinceramiento o otro tarifazo?','El Decreto Supremo 5676 quitó la subvención al diésel para grandes consumidores e industrias. El referencial subió cerca de 18 Bs el litro; transporte y particulares se mantienen en torno a 9,80. El Gobierno habla de filas, de “clientes directos” y de años de subvención financiada con reservas. Los productores hablan de costos, alimentos y paralización. ¿Se acaba el privilegio industrial o se transfiere la crisis al precio de la comida?','economia',1,'open','debates/images/ypfb-lapaz.jpg','Edificio YPFB, La Paz. Wikimedia Commons / EEJCC (CC BY-SA 4.0).',NULL,NULL,'[{\"url\": \"https://efe.com/economia/2026-08-17/bolivia-subvencion-precio-diesel-consumidores-combustible/\", \"name\": \"EFE — Bolivia quita la subvención al diésel para grandes consumidores\"}, {\"url\": \"https://apnews.com/article/bolivia-rodrigo-paz-crisis-energetica-subsidios-crisis-economica-7c3d07fa22adc934f381827716c5e6b6\", \"name\": \"AP News — crisis de combustibles y decreto 5676\"}]','2026-08-13 14:31:22','2026-08-22 08:31:22'),(3,'Censura a Espinoza: ¿la Asamblea fiscaliza o toma el Ministerio?','La ALP censuró al ministro de Economía José Gabriel Espinoza (91-34-4) por no ir a la interpelación: alegó coordinación por diésel en Santa Cruz y viaje a Brasil. El 21 de agosto Rodrigo Paz lo destituyó y dejó interino a Óscar Mario Justiniano. Espinoza fue al Tribunal Constitucional. ¿La censura es control democrático, o un Legislativo que usa la crisis para descabezar al gabinete?','politica',1,'open','debates/images/casa-grande.jpg','Casa Grande del Pueblo, La Paz. Wikimedia Commons / Fernando6718 (CC BY-SA 4.0).',NULL,NULL,'[{\"url\": \"https://eldeber.com.bo/pais/rodrigo-paz-cambia-espinoza-mientras-espera-decision-constitucional_1787320630\", \"name\": \"El Deber — Paz destituye a Espinoza y nombra interino\"}, {\"url\": \"https://www.infobae.com/america/america-latina/2026/08/19/el-congreso-de-bolivia-censuro-al-ministro-de-economia-por-no-asistir-a-una-interpelacion/\", \"name\": \"Infobae — la ALP censura al ministro de Economía\"}]','2026-08-14 14:31:23','2026-08-22 09:31:23'),(4,'Caso Cerimedo–Beller: ¿gobierno invisible o denuncia sin pruebas?','Tras el atentado contra Nadia Beller en Santa Cruz, la abogada acusó a Fernando Cerimedo —asesor del entorno presidencial, sin planilla estatal clara— de negociados con combustibles, oro y operadores privados, e involucró al círculo de Rodrigo Paz. El Gobierno pidió pruebas y dijo que colaborará. El caso mezcla tentativa de feminicidio, audios, traders y la crisis del diésel. ¿Se investiga todo, o se tapa porque quema?','politica',1,'open','debates/images/ciudad-bo.jpg','Ciudad boliviana. Unsplash (foto de La Paz, Bolivia).',NULL,NULL,'[{\"url\": \"https://www.lanacion.com.ar/politica/las-acusaciones-de-nadia-beller-contra-fernando-cerimedo-cajones-con-billetes-negociados-y-una-elite-nid18082026/\", \"name\": \"La Nación — acusaciones de Beller contra Cerimedo\"}, {\"url\": \"https://www.telesurtv.net/bolivia-beller-red-corrupcion-presidencial/\", \"name\": \"teleSUR — denuncia e entorno presidencial\"}, {\"url\": \"https://eju.tv/2026/08/el-colapso-del-gobierno-invisible/\", \"name\": \"eju.tv — el colapso del “gobierno invisible”\"}]','2026-08-15 14:31:23','2026-08-22 10:31:23'),(5,'Estado de excepción hasta octubre: ¿orden o miedo a la calle?','Tras 53 días de bloqueos por precios y combustibles, el gobierno de Paz decretó estado de excepción para frenar protestas, con vigencia hacia octubre. Sindicatos hablan de criminalizar la demanda; el Ejecutivo, de asfixia a las ciudades. ¿Se puede gobernar una crisis energética con excepción permanente, o se está normalizando el recorte de derechos?','seguridad',1,'open','debates/images/calle-lpz.jpg','Calle en La Paz, Bolivia. Unsplash.',NULL,NULL,'[{\"url\": \"https://apnews.com/article/bolivia-rodrigo-paz-crisis-energetica-subsidios-crisis-economica-7c3d07fa22adc934f381827716c5e6b6\", \"name\": \"AP News — bloqueos, estado de excepción y crisis de combustibles\"}, {\"url\": \"https://www.lapoliticaonline.com/amp/354051-el-caso-cerimedo-complica-al-gobierno-de-paz-en-bolivia/\", \"name\": \"La Política Online — excepción y gobernabilidad\"}]','2026-08-16 14:31:23','2026-08-22 11:31:23'),(6,'¿Deben los legisladores levantar el secreto bancario —y el de su familia?','Tras la lista de Beller, diputados de Libre pidieron que asambleístas y ministros renuncien al secreto bancario, incluso de familiares de primer grado, y que se investiguen “pegas” en empresas públicas del oriente. Otros dicen que sin prueba previa es un show y un riesgo para terceros. ¿Transparencia total del cargo público, o cacería?','politica',1,'open','debates/images/asamblea-plaza.jpg','Asamblea Legislativa Plurinacional, Plaza Murillo, La Paz. Wikimedia Commons / Yastay (CC BY-SA 4.0).',NULL,NULL,'[{\"url\": \"https://eju.tv/2026/08/sobresueldos-libre-pide-a-legisladores-y-autoridades-del-gobierno-renunciar-al-secreto-bancario-y-pdc-investigar-pagos/\", \"name\": \"eju.tv — pedido de secreto bancario y pegas estatales\"}, {\"url\": \"https://exitonoticias.com.bo/tras-ser-mencionados-en-la-lista-de-beller-diputados-exigen-pruebas-y-solicitan-levantar-el-secreto-bancario/400908/\", \"name\": \"Éxito Noticias — diputados piden pruebas y abrir cuentas\"}]','2026-08-17 14:31:23','2026-08-22 12:31:23'),(7,'Filas, cupos y YPFB: ¿quién decide quién carga gasolina?','Las estaciones volvieron a las filas. Se denuncia un presunto cobro informal por litro para asignar cupos de gasolina y diésel, y operadores privados en la cadena de importación. YPFB y el Ministerio hablan de abastecimiento urgente; la gente habla de privilegiados que cargan de noche. ¿Crisis logística, o mercado paralelo con sello estatal?','infraestructura',1,'open','debates/images/da5EZ87dPF1mLtqyNT1k7Sl0tPIEhh8bzAlG5YII.jpg','Torre YPFB, Camiri, Santa Cruz. Wikimedia Commons / Ariela2020 (CC BY-SA 4.0).',NULL,NULL,'[{\"url\": \"https://eju.tv/2026/08/el-colapso-del-gobierno-invisible/\", \"name\": \"eju.tv — cupos de combustible y operadores privados\"}, {\"url\": \"https://efe.com/economia/2026-08-17/bolivia-subvencion-precio-diesel-consumidores-combustible/\", \"name\": \"EFE — filas en estaciones y decreto de grandes consumidores\"}]','2026-08-18 14:31:24','2026-08-22 18:13:35'),(8,'Oro, reservas y traders: ¿se está vendiendo el colchón del país?','El Gobierno atribuye años de subvención de combustibles a reservas e incluso a oro. Las denuncias de agosto hablan de negociados con metal y con la importación de carburantes. El BCB no es un kiosco: cada lingote que se va para tapar el tanque es política monetaria. ¿Emergencia inevitable, o saqueo con justificativo técnico?','economia',1,'open','debates/images/cerro-rico.jpg','Cerro Rico, Potosí. Wikimedia Commons / Christophe Meneboeuf (CC BY-SA 2.5).',NULL,NULL,'[{\"url\": \"https://www.lanacion.com.ar/politica/las-acusaciones-de-nadia-beller-contra-fernando-cerimedo-cajones-con-billetes-negociados-y-una-elite-nid18082026/\", \"name\": \"La Nación — denuncias de negociados con oro y combustibles\"}, {\"url\": \"https://eju.tv/2026/08/el-colapso-del-gobierno-invisible/\", \"name\": \"eju.tv — oro, cupos y el entorno del poder\"}]','2026-08-19 14:31:24','2026-08-22 14:31:24'),(9,'Pegas en empresas públicas: ¿el cargo es mérito o apellido?','En el mismo paquete de denuncias de agosto se pidió investigar directorios y puestos en empresas del Estado —ENDE y otras del oriente— donde aparecerían familiares de parlamentarios. No es un escándalo nuevo: es el software viejo. ¿Se puede hablar de recambio si el organigrama sigue siendo un árbol genealógico?','politica',1,'open','debates/images/teleferico-unsplash.jpg','Mi Teleférico, La Paz. Unsplash.',NULL,NULL,'[{\"url\": \"https://eju.tv/2026/08/sobresueldos-libre-pide-a-legisladores-y-autoridades-del-gobierno-renunciar-al-secreto-bancario-y-pdc-investigar-pagos/\", \"name\": \"eju.tv — investigación de pegas y familiares en empresas del Estado\"}]','2026-08-20 14:31:24','2026-08-22 15:31:24'),(10,'Gobernabilidad 2026: ¿Paz termina el mandato o el país se va a revocatorio?','Nueve meses de gobierno, excepción, censura ministerial, filas de combustible y una denuncia que apunta al entorno presidencial. Hay quienes hablan de adelantar elecciones o empujar un revocatorio después del ciclo electoral. Otros dicen que destituir a cada presidente en crisis es el verdadero atraso. ¿Se aguanta y se investiga, o se abre otro ciclo de palacio?','politica',1,'open','debates/images/APAR4MOKfTU1U4VYHejAsc2GvhR1uOwEqCmKmLOK.jpg','La Paz, Bolivia. Unsplash.',NULL,'https://youtu.be/bFUKPSoUjog?si=JTxebuMJFBDF8zTS','[{\"url\": \"https://www.lapoliticaonline.com/amp/354051-el-caso-cerimedo-complica-al-gobierno-de-paz-en-bolivia/\", \"name\": \"La Política Online — crisis de gobernabilidad y escenario de revocatorio\"}, {\"url\": \"https://apnews.com/article/bolivia-rodrigo-paz-crisis-energetica-subsidios-crisis-economica-7c3d07fa22adc934f381827716c5e6b6\", \"name\": \"AP News — nueve meses de gobierno, filas y excepción\"}]','2026-08-21 14:31:24','2026-08-22 18:10:40');
/*!40000 ALTER TABLE `debates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `debate_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `messages_user_id_foreign` (`user_id`),
  KEY `messages_parent_id_foreign` (`parent_id`),
  KEY `messages_debate_id_created_at_index` (`debate_id`,`created_at`),
  CONSTRAINT `messages_debate_id_foreign` FOREIGN KEY (`debate_id`) REFERENCES `debates` (`id`) ON DELETE CASCADE,
  CONSTRAINT `messages_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `messages` (`id`) ON DELETE SET NULL,
  CONSTRAINT `messages_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,1,1,'Abrimos el hilo con lo que está en la calle: denuncia de sobresueldos, lista circulando y asambleístas que piden pruebas o secreto bancario. Argumentos, no linchamiento. Los comentarios de este debate son de participantes de la plataforma.',NULL,'2026-08-22 14:31:22','2026-08-22 14:31:22'),(2,1,10,'Si un diputado necesita 5.000 dólares extra para “acompañar” al Ejecutivo, no es legislador: es operador. Da igual el color. La Viejocracia no es edad, es atrincherarse con la chequera ajena.',NULL,'2026-08-22 14:43:22','2026-08-22 14:43:22'),(3,1,6,'Concuerdo en el fondo, pero una lista sin documentos no es prueba. Si mañana me ponen a mí, ¿también me linchan en redes y después “ah, era un error”?',2,'2026-08-22 14:49:22','2026-08-22 14:49:22'),(4,1,10,'Por eso hay que levantar secreto bancario de todos, no de los que caen mal. Si están limpios, 48 horas y se acaba el show.',2,'2026-08-22 15:01:22','2026-08-22 15:01:22'),(5,1,5,'En Santa Cruz ya nadie se sorprende. El que cree que las leyes salen solo por ideología no ha visto cómo se arman las mayorías. Lo grave es que el diésel falta y ellos discutirían la cifra.',NULL,'2026-08-22 14:55:22','2026-08-22 14:55:22'),(6,1,9,'Ojo: esto también se usa para golpear a Quiroga y a Libre. Las listas van y vienen cada crisis. Quiero investigación, no un ajuste de cuentas disfrazado de moral.',NULL,'2026-08-22 15:07:22','2026-08-22 15:07:22'),(7,1,14,'Las dos cosas pueden ser ciertas: que haya operador sucio y que la denuncia sirva de granada. Por eso la Fiscalía tiene que trabajar con papeles, no con capturas de WhatsApp.',6,'2026-08-22 15:13:22','2026-08-22 15:13:22'),(8,1,12,'Yo hago fila por un pan y un litro. Ellos discuten si 5.000 dólares es “colaboración política”. Que publiquen cuentas de ellos y de la familia. Sin teatro.',NULL,'2026-08-22 15:19:22','2026-08-22 15:19:22'),(9,1,8,'La comisión de la Asamblea investigándose a sí misma es un chiste. Tiene que ser externa, con plazos y con informe público. Si no, en dos semanas esto se pudre y nadie dimite.',NULL,'2026-08-22 15:31:22','2026-08-22 15:31:22'),(10,2,1,'El decreto ya está en vigor: industrias y grandes consumidores pagan diésel sin subvención. ¿Es el único camino para que haya combustible en surtidor, o es el comienzo de otro tarifazo en cadena?',NULL,'2026-08-22 14:31:22','2026-08-22 14:31:22'),(11,2,13,'En el Beni el agro no es “gran consumidor de lujo”. Sin diésel no hay cosecha ni flete. Si me lo ponen a 18, el arroz y la carne no van a esperar el discurso de sinceramiento: van a subir la semana que viene.',NULL,'2026-08-22 14:43:22','2026-08-22 14:43:22'),(12,2,5,'Exacto. El soya, el transporte de carga y la industria alimentaria somos el mismo eslabón. Quieren “salvar el surtidor” asfixiando al que produce.',11,'2026-08-22 14:49:22','2026-08-22 14:49:22'),(13,2,3,'Y si no lo hacen, el surtidor sigue seco y el productor igual para. El subsidio infinito ya quebró las reservas. El problema es el cómo y a quién se le cobra primero.',11,'2026-08-22 15:01:23','2026-08-22 15:01:23'),(14,2,7,'A mí me dejaron el precio “social” y igual hago cola desde las 4 de la mañana. Entonces ¿la subvención llega al que maneja, o se la quedan los que tienen cupo?',NULL,'2026-08-22 14:55:23','2026-08-22 14:55:23'),(15,2,11,'En minería el diésel es costo directo. Sin regla clara de quién es “grande consumidor” esto se presta a amigo y enemigo. Publiquen el padrón de cupos, no un PowerPoint.',NULL,'2026-08-22 15:07:23','2026-08-22 15:07:23'),(16,2,4,'Durante años se subvencionó con oro y reservas para que el precio mienta. Eso también es Viejocracia económica: patear la cuenta a la generación que viene. Duele, pero el precio falso ya nos estalló.',NULL,'2026-08-22 15:19:23','2026-08-22 15:19:23'),(17,3,1,'Primer ministro censurado del gobierno de Paz. El Ejecutivo tardó, el ministro se ausentó, la ALP votó. ¿Fiscalización o golpe de recinto?',NULL,'2026-08-22 14:31:23','2026-08-22 14:31:23'),(18,3,14,'Un ministro de Economía que no se sienta a explicar la crisis del diésel le está diciendo al país que el Congreso estorba. La interpelación no es opcional.',NULL,'2026-08-22 14:43:23','2026-08-22 14:43:23'),(19,3,6,'También es cierto que lo citan cuando está apagando incendios. Si cada ministro cae por no ir, vamos a tener gabinete rotativo y cero política económica.',18,'2026-08-22 14:49:23','2026-08-22 14:49:23'),(20,3,10,'Me importa menos el nombre que el patrón: se censura, se ampara, se nombra interino al de Producción. El cargo se recicla entre los mismos. Eso es Viejocracia de organigrama.',NULL,'2026-08-22 14:55:23','2026-08-22 14:55:23'),(21,3,9,'Espinoza ya se había perdido otra citación por el FMI. No es un accidente: es desprecio. Que rinda cuentas o que se vaya. El pueblo no puede “viajar a Brasil”.',NULL,'2026-08-22 15:07:23','2026-08-22 15:07:23'),(22,3,5,'Si lo sacan y el diésel sigue igual, fue teatro. Quiero ver qué hace Justiniano con el 5676, no otro comunicado de “continuidad del servicio”.',NULL,'2026-08-22 15:19:23','2026-08-22 15:19:23'),(23,3,8,'El TC no debería ser el plan B de todo ministro censurado. Si la SCP 20/2023 dice que hay 24 horas para destituir, se cumple. Punto. Después que litiguen.',NULL,'2026-08-22 15:31:23','2026-08-22 15:31:23'),(24,4,1,'Hay un hecho de violencia gravísimo y hay denuncias de corrupción que todavía se tienen que probar. Se pueden exigir las dos investigaciones. No las mezclen para anularse.',NULL,'2026-08-22 14:31:23','2026-08-22 14:31:23'),(25,4,12,'Una mujer baleada denuncia al operador del poder. Si el Estado responde “traiga pruebas” y no resguarda, ya sabemos de qué lado está. Primero la vida, después el organigrama.',NULL,'2026-08-22 14:43:23','2026-08-22 14:43:23'),(26,4,6,'Resguardo sí. Condena mediática al Presidente sin expediente, no. En este país una entrevista de hospital ya vale como sentencia.',25,'2026-08-22 14:49:23','2026-08-22 14:49:23'),(27,4,3,'Lo que más me jode: un asesor que “no está en planilla” pero mueve combustibles y puertas. Eso es el gobierno invisible. Si Paz no lo cortó, es su responsabilidad política aunque el juez todavía no hable.',NULL,'2026-08-22 14:55:23','2026-08-22 14:55:23'),(28,4,4,'Los audios con YPFB y traders, si existen, tienen que peritarse y publicarse con cadena de custodia. Si no existen, alguien está dinamitando el país con un pendrive.',NULL,'2026-08-22 15:07:23','2026-08-22 15:07:23'),(29,4,15,'En Tarija el rumor ya es mercado. Baja la confianza, sube el dólar paralelo, y el almacén cierra más temprano. La política sucia se paga en la feria, no en el palacio.',NULL,'2026-08-22 15:19:23','2026-08-22 15:19:23'),(30,4,10,'Investigación sin candado político: Cerimedo, cupos, oro, sobresueldos. El cortafuegos institucional o esto se come al gobierno y a la oposición juntos.',NULL,'2026-08-22 15:31:23','2026-08-22 15:31:23'),(31,5,1,'La excepción ya no es “un fin de semana de emergencia”. Es el marco de la política cotidiana. ¿Hasta cuándo?',NULL,'2026-08-22 14:31:23','2026-08-22 14:31:23'),(32,5,9,'Nos cortan el derecho a protestar porque el diésel no llega. Es al revés: protestamos porque el Estado no cumple. La excepción es el palo para no escuchar.',NULL,'2026-08-22 14:43:23','2026-08-22 14:43:23'),(33,5,12,'Hermano, 53 días de bloqueo también es violencia contra el que trabaja. Mi hijo no llegó a la escuela. El sindicato no es dueño de la carretera.',32,'2026-08-22 14:49:23','2026-08-22 14:49:23'),(34,5,9,'Sin carretera no nos ven. Con excepción tampoco. Entonces ¿cuál es el canal? ¿Twitter del ministro?',32,'2026-08-22 15:01:23','2026-08-22 15:01:23'),(35,5,7,'Yo perdí dos semanas parado. Ni el bloqueo me dio diésel ni la excepción me llenó el tanque. Las dos recetas fracasaron para el que vive del volante.',NULL,'2026-08-22 14:55:23','2026-08-22 14:55:23'),(36,5,8,'Un gobierno joven que gobierna con estado de excepción es una contradicción. Se puede ser nuevo y viejócrata: el palo es el método de siempre.',NULL,'2026-08-22 15:07:23','2026-08-22 15:07:23'),(37,5,6,'Sin orden no hay reforma. El 5676 no se aplica si cada sector toma una tranca. El problema es usarlo para callar periodistas y opositores, no para abrir rutas.',NULL,'2026-08-22 15:19:23','2026-08-22 15:19:23'),(38,6,1,'La propuesta ya está en el recinto: cuentas de legisladores y de su entorno. ¿Línea roja democrática o el mínimo ético del cargo?',NULL,'2026-08-22 14:31:23','2026-08-22 14:31:23'),(39,6,10,'Si manejás presupuesto y leyes, tu cuenta no es intimidad: es conflicto de interés permanente. Familia de primer grado incluida. El que se ofende, que se vaya a la privada.',NULL,'2026-08-22 14:43:23','2026-08-22 14:43:23'),(40,6,14,'Cuidado con el cónyuge que tiene empresa propia de hace 20 años. Hay que acotar: movimientos atípicos, no espiar la vida. Si no, mañana el gobierno de turno usa esto contra la bancada que estorba.',39,'2026-08-22 14:49:23','2026-08-22 14:49:23'),(41,6,11,'En Potosí hemos visto diputados pobres de discurso y ricos de camioneta. El secreto bancario es el candado de esa magia. Que lo abran.',NULL,'2026-08-22 14:55:23','2026-08-22 14:55:23'),(42,6,5,'Que investiguen también las directorios de empresas públicas. El sobresueldo no es solo sobre. A veces es el cuñado en ENDE.',NULL,'2026-08-22 15:07:23','2026-08-22 15:07:23'),(43,6,6,'Apoyo transparencia. Rechazo linchamiento por PDF anónimo. Orden: comisión, peritos, plazos, nombres con cargo y monto, no un Excel de WhatsApp.',NULL,'2026-08-22 15:19:23','2026-08-22 15:19:23'),(44,7,1,'Pregunta simple: si el precio “social” se mantiene para el particular, ¿por qué el tanque sigue vacío? Cupos, logística o privilegio.',NULL,'2026-08-22 14:31:24','2026-08-22 14:31:24'),(45,7,7,'Hay estaciones donde el particular hace 6 horas y pasa un camión con “autorización”. Eso no es escasez: es ventanilla. Publiquen el cupo por surtidor, hora por hora.',NULL,'2026-08-22 14:43:24','2026-08-22 14:43:24'),(46,7,13,'En el norte pasa igual con el diésel agrícola. El que tiene contacto carga; el que tiene chaco espera. Así se pudre el país.',45,'2026-08-22 14:49:24','2026-08-22 14:49:24'),(47,7,15,'El flete ya me come el margen. Si hay traders cobrando comisión por litro, eso es un impuesto clandestino. Fiscalía y YPFB tienen que mostrar contratos, no eslóganes.',NULL,'2026-08-22 14:55:24','2026-08-22 14:55:24'),(48,7,3,'Plataforma pública de cupos. Si el Estado no puede mostrar quién carga, entonces el Estado no está administrando el combustible: lo está repartiendo.',NULL,'2026-08-22 15:07:24','2026-08-22 15:07:24'),(49,7,9,'También hay acaparamiento y reventa. No todo es palacio. Hay surtidor que esconde y hay sindicalista que negocia. Limpieza de los dos lados.',NULL,'2026-08-22 15:19:24','2026-08-22 15:19:24'),(50,7,4,'Mientras el oro y las reservas paguen el litro barato para algunos, el resto va a seguir en cola. El cupo es la nueva aduana interna.',NULL,'2026-08-22 15:31:24','2026-08-22 15:31:24'),(51,8,1,'El hilo no es contra el minero. Es contra usar el metal del país para sostener un precio político hasta que ya no hay metal ni precio.',NULL,'2026-08-22 14:31:24','2026-08-22 14:31:24'),(52,8,11,'En Potosí sacamos el mineral y La Paz decide el destino. Si el oro se va a pagar diésel de industria y comisión de trader, que lo digan con cifra. No con “es por el pueblo”.',NULL,'2026-08-22 14:43:24','2026-08-22 14:43:24'),(53,8,10,'Eso. Auditoría de reservas, de ventas y de intermediarios. Si hay comisión de un boliviano por litro, eso es más rentable que cualquier mina chica.',52,'2026-08-22 14:49:24','2026-08-22 14:49:24'),(54,8,8,'Quemar reservas para no tocar el precio es la receta de siempre. Después viene el “no hay dólares” y la culpa es del ciudadano que “especula”. No. La cuenta la hizo el Estado.',NULL,'2026-08-22 14:55:24','2026-08-22 14:55:24'),(55,8,5,'Sin dólares no hay diésel importado. Sin diésel no hay agro. El círculo es real. Lo que no puede ser real es que el círculo lo administren amigos del entorno.',NULL,'2026-08-22 15:07:24','2026-08-22 15:07:24'),(56,8,6,'Pidamos informes del BCB en lenguaje humano: cuánto oro, a quién, a qué precio, para qué factura de combustible. Si eso es secreto, el secreto ya es el problema.',NULL,'2026-08-22 15:19:24','2026-08-22 15:19:24'),(57,9,1,'El hilo de Viejocracia entra acá de lleno: no es la edad del director, es si el cargo se hereda. Nombres, hojas de vida y fechas de ingreso, no rumor.',NULL,'2026-08-22 14:31:24','2026-08-22 14:31:24'),(58,9,10,'Un país con mediana de 25 años y directorios de siempre. La cuota de renovación no es capricho: es oxigenar. Si tu cónyuge entra a ENDE la semana que votás una ley, eso no es coincidencia.',NULL,'2026-08-22 14:43:24','2026-08-22 14:43:24'),(59,9,9,'En las empresas del Estado también hay trabajador de base que no es cuñado de nadie. No usen esto para tercerizar y echar gente. Apunten al directorio, no al electricista.',58,'2026-08-22 14:49:24','2026-08-22 14:49:24'),(60,9,14,'Hoja de vida pública de todo director de empresa estatal. Título, experiencia, parentesco con asambleístas. Si duele, es que funciona.',NULL,'2026-08-22 14:55:24','2026-08-22 14:55:24'),(61,9,13,'Mientras el chaco no tiene diésel, hay gente cobrando en directorio por “representar al área rural”. Representen trayendo combustible, no trayendo al primo.',NULL,'2026-08-22 15:07:24','2026-08-22 15:07:24'),(62,9,12,'Mi hija egresó y no hay pega. El hijo del dirigente sí. Eso es la Viejocracia cotidiana, no un paper. Basta.',NULL,'2026-08-22 15:19:24','2026-08-22 15:19:24'),(63,10,1,'Última pregunta del tablero: ¿la salida es institucional (investigar, transparentar, reformar el diésel) o es otra vez tumbar al que está sentado?',NULL,'2026-08-22 14:31:24','2026-08-22 14:31:24'),(64,10,6,'Revocatorio ahora es echar nafta al tanque vacío. Primero investigación, cupos públicos y un ministro de Economía que vaya al Congreso. Si en 90 días no hay nada, hablamos de urnas.',NULL,'2026-08-22 14:43:24','2026-08-22 14:43:24'),(65,10,10,'90 días es una eternidad cuando no hay diésel. El reloj lo pone la fila, no el calendario de La Paz.',64,'2026-08-22 14:49:24','2026-08-22 14:49:24'),(66,10,9,'Este gobierno pidió paciencia y mandó excepción. La calle no va a esperar 2028. Si no hay diésel y hay operadores invisibles, el mandato ya está vacío.',NULL,'2026-08-22 14:55:24','2026-08-22 14:55:24'),(67,10,5,'Cambiar de presidente cada crisis es la costumbre que nos quebró. Quiero ver si Paz corta a su entorno. Si no corta, se cae solo. Si corta, tal vez gobierna.',NULL,'2026-08-22 15:07:24','2026-08-22 15:07:24'),(68,10,8,'La Viejocracia también es creer que el país se arregla con otro nombre en el palacio y el mismo método. Recambio de práctica, no solo de foto.',NULL,'2026-08-22 15:19:24','2026-08-22 15:19:24'),(69,10,3,'Investiguen ya: sobresueldos, cupos, oro, Cerimedo. Publiquen. El que esté limpio sigue. El que no, presidio. Sin eso, cualquier revocatorio es solo otra pelea de cúpulas.',NULL,'2026-08-22 15:31:24','2026-08-22 15:31:24');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2026_08_16_191944_create_personal_access_tokens_table',2),(5,'2026_08_16_200000_add_nick_and_email_hash_to_users_table',3),(6,'2026_08_16_200001_create_debates_table',3),(7,'2026_08_16_200002_create_messages_table',3),(8,'2026_08_16_200003_create_vote_topics_table',3),(9,'2026_08_16_200004_create_signatures_table',3),(10,'2026_08_16_210000_create_militants_table',4),(11,'2026_08_22_130000_add_image_credit_and_sources_to_debates',5),(12,'2026_08_22_140000_add_is_admin_to_users_table',6);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  KEY `personal_access_tokens_expires_at_index` (`expires_at`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
INSERT INTO `personal_access_tokens` VALUES (1,'App\\Models\\User',2,'spa','46ec0eaa6916e5379b67d901699c21b93ff013c0c98f157276a8e9a16355095f','[\"*\"]','2026-08-17 01:40:18',NULL,'2026-08-17 00:05:48','2026-08-17 01:40:18'),(3,'App\\Models\\User',16,'spa','4c3c3a7668fe79df0f16c034f4e086fed7d529105885cac4deeae5b0675f2bbb','[\"*\"]','2026-08-23 23:12:20',NULL,'2026-08-23 23:06:03','2026-08-23 23:12:20'),(5,'App\\Models\\User',16,'spa','1f8750fbb0b4614eb8366536fda846eeaa56b228a0029694771dcb9fd62ad2e3','[\"*\"]','2026-08-24 00:19:49',NULL,'2026-08-23 23:32:01','2026-08-24 00:19:49');
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `signatures`
--

DROP TABLE IF EXISTS `signatures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `signatures` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `vote_topic_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `email_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ci_hash` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `signatures_vote_topic_id_user_id_unique` (`vote_topic_id`,`user_id`),
  UNIQUE KEY `signatures_vote_topic_id_email_hash_unique` (`vote_topic_id`,`email_hash`),
  UNIQUE KEY `signatures_vote_topic_id_ci_hash_unique` (`vote_topic_id`,`ci_hash`),
  KEY `signatures_user_id_foreign` (`user_id`),
  CONSTRAINT `signatures_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `signatures_vote_topic_id_foreign` FOREIGN KEY (`vote_topic_id`) REFERENCES `vote_topics` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `signatures`
--

LOCK TABLES `signatures` WRITE;
/*!40000 ALTER TABLE `signatures` DISABLE KEYS */;
/*!40000 ALTER TABLE `signatures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nick` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_hash` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT '0',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  UNIQUE KEY `users_nick_unique` (`nick`),
  UNIQUE KEY `users_email_hash_unique` (`email_hash`),
  KEY `users_is_admin_index` (`is_admin`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Redacción','redaccion','demo@viejocracia.test','4e3a6dd50c8e94e84b684c78bfd3b6e34ca88d8003e2f81213da1625d4d15950',NULL,'$2y$12$gOHTHcxEys4hdy7IDfOK9eolQ3QCwyaigDl3ofz3k2d1SbXtKCc5W',0,NULL,'2026-08-17 00:01:57','2026-08-17 00:01:57'),(2,'jota','jota','huancajuan863@gmail.com','2083269563f9f7ba60d04e93b5c71f28910937f4c8451217827d15edbdf8ca2a',NULL,'$2y$12$vzjgFFCcfZMueuPdb7LLV.E9mYqBQtd9B0ypPuG.NsMZ1sM9Vn3Jq',0,NULL,'2026-08-17 00:05:48','2026-08-17 00:05:48'),(3,'Vecino LPZ','vecino_lpz','vecino_lpz@viejocracia.test','728e4dd83e66e2f60ae61fd8fa4c889858e61210b1d67122c2bb5ebc0c8444b8',NULL,'$2y$12$OWNBlAoIAwefa3oDRDAkuOVLZWcOYgY8lmmcnTn9dPNxx0KuDeCPy',0,NULL,'2026-08-22 17:23:05','2026-08-22 17:23:05'),(4,'Yungas Verde','yungas_verde','yungas_verde@viejocracia.test','d6ed4bc46a45d0ab043803770ad6ede238f75678abe3bf55f03f2cbd4918e6ff',NULL,'$2y$12$W67RDMX.hGXP2GBMLXFVp.xq1OQQBrxaIQC18Xwy5XCAtLr7//6t.',0,NULL,'2026-08-22 17:23:06','2026-08-22 17:23:06'),(5,'Cruceña Prod','crucena_prod','crucena_prod@viejocracia.test','d77922c8d5694b39c2d6ff02c346941d10d126863f6c7ea45d707f0a78d16748',NULL,'$2y$12$Br4G8NrXxmlLaU8tEQLf1..10.RvbgJfZufmUq/HEguiVqyvsj6mS',0,NULL,'2026-08-22 17:23:06','2026-08-22 17:23:06'),(6,'Paceño Sur','paceno_sur','paceno_sur@viejocracia.test','5669c68b56616323c2be480f4037e76316e9a5a5ee3a223e7004fe84b41214e4',NULL,'$2y$12$2.2fJqd8ePszC/lmaF3BUuLF5UYe/JgCWHdhLoK2V4S6nI32nHlTe',0,NULL,'2026-08-22 17:23:06','2026-08-22 17:23:06'),(7,'Chofer SCZ','chofer_scz','chofer_scz@viejocracia.test','f0b0644810970ef5d7dfed986b3124763df987e613acaf647001c0372d5e6a81',NULL,'$2y$12$q9/bHrFhMW8sLpvvuRIH4.Md74XGEw9tG8G2HEZKTBpc/A9z/SDMG',0,NULL,'2026-08-22 17:23:06','2026-08-22 17:23:06'),(8,'Docente Oruro','docente_oruro','docente_oruro@viejocracia.test','ffb83b3a8715e2a3e3649bbbb6266461ff21fd59713293a4b6bc30b83ff86090',NULL,'$2y$12$9BXz3hr.2KuIJ0GZ9sboNOTVCbCR81Sy7ceujDnuHAVE5k55TDTrW',0,NULL,'2026-08-22 17:23:07','2026-08-22 17:23:07'),(9,'Sindical LPZ','sindical_lpz','sindical_lpz@viejocracia.test','f0a460c3672eec0e84858ecf7265dc71290a834250e519e833ebf3314325a99c',NULL,'$2y$12$eUKoMqmZTXZp5e0t7/VzQOBhkhp462NpfgaGUNu5DlC4Mtc0AWJkW',0,NULL,'2026-08-22 17:23:07','2026-08-22 17:23:07'),(10,'Joven SCR','joven_scr','joven_scr@viejocracia.test','2c85adfdeb45784c9f43f649c91c2c013fe58ecb8c8a8fa6533da754422ee3c1',NULL,'$2y$12$9iADfpn1j4XfOFYXb.jZceE0SNurOigJBBmizebCGvnRSIa2TtHqa',0,NULL,'2026-08-22 17:23:07','2026-08-22 17:23:07'),(11,'Minería Potosí','mineria_potosi','mineria_potosi@viejocracia.test','45201702cef483cf362ab0a97ae586937f676e4826737ba4c6b2b1f3c39adeea',NULL,'$2y$12$WCUY4.EGTguP3ovsg3QML.tFU.kTT.YX3dGGeLE3Bh0zjPGfcvyXi',0,NULL,'2026-08-22 17:23:07','2026-08-22 17:23:07'),(12,'Madre El Alto','madre_elalto','madre_elalto@viejocracia.test','c3847f2993a856f497a64cc8aaba0376109bba2cb7233f6b629e257190ee6ae9',NULL,'$2y$12$KE9uZaqsQgo16.Sfvr4CDeNYxebWvn.7WDcXabL3m/Cz2/fMNoYPa',0,NULL,'2026-08-22 17:23:07','2026-08-22 17:23:07'),(13,'Agro Beni','agro_beni','agro_beni@viejocracia.test','ad966698a67279639d5fc8598ade4229280510b28ffcdecd2b074d87ff6a5944',NULL,'$2y$12$/33Q4shK54cxcWsyKvlpB.118rV3//7ZlnX5NkMC.2094HSYng0Dm',0,NULL,'2026-08-22 17:23:08','2026-08-22 17:23:08'),(14,'Uni Cbba','uni_cbba','uni_cbba@viejocracia.test','60bfc7d85ef7a629d83e41a34e1e3a23ccb11b2bdfb4afb6da5ed9a60607f91f',NULL,'$2y$12$lfZ5S8ukLBTve0wxdI00MO4OY7HjuuU/FAFPiQxhCMp/2GnFmwARe',0,NULL,'2026-08-22 17:23:08','2026-08-22 17:23:08'),(15,'Comerciante Tarija','comerciante_tz','comerciante_tz@viejocracia.test','c030d254cd3419b301d6c74b9f434cecb6c7974be6e31a63da70cee839bbaa9f',NULL,'$2y$12$0uEJVPRniTXPd/zi5tnDuu3XnxwoeaUZpXgfdgPzdCZ1YnvROTs0O',0,NULL,'2026-08-22 17:23:08','2026-08-22 17:23:08'),(16,'Administrador','admin','admin@viejocracia.test','6e7a5e0a5accc55aaff451192328d554f32b2bb11434adc8900ac7afbeddb62f',NULL,'$2y$12$938IaSYeDDiOh4ZZ97yv7OiKKudmrM138AZpvL2rP8E1DERpKSkp.',1,NULL,'2026-08-22 18:02:01','2026-08-22 18:02:01');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vote_topics`
--

DROP TABLE IF EXISTS `vote_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vote_topics` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `author_id` bigint unsigned NOT NULL,
  `target_signatures` int unsigned NOT NULL DEFAULT '0',
  `signatures_count` int unsigned NOT NULL DEFAULT '0',
  `deadline` timestamp NULL DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'open',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `vote_topics_author_id_foreign` (`author_id`),
  KEY `vote_topics_status_deadline_index` (`status`,`deadline`),
  CONSTRAINT `vote_topics_author_id_foreign` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vote_topics`
--

LOCK TABLES `vote_topics` WRITE;
/*!40000 ALTER TABLE `vote_topics` DISABLE KEYS */;
INSERT INTO `vote_topics` VALUES (1,'Comisión independiente para investigar presuntos sobresueldos','Fuera de la ALP: peritos, secreto bancario voluntario de asambleístas y informe público en 60 días.',1,8000,2140,'2026-10-01 17:31:24','open','2026-08-14 17:31:24','2026-08-22 17:31:24'),(2,'Cupos de diésel y gasolina en tiempo real','YPFB debe publicar estación, volumen y tipo de cliente. Sin padrón a oscuras no hay subvención creíble.',1,10000,4310,'2026-09-27 17:31:24','open','2026-08-15 17:31:24','2026-08-22 17:31:24'),(3,'Levantar el secreto bancario de legisladores en ejercicio','Cuentas propias y de familiares de primer grado mientras dure el mandato. El cargo no es intimidad.',1,6500,1980,'2026-09-23 17:31:24','open','2026-08-16 17:31:24','2026-08-22 17:31:24'),(4,'Derogar el estado de excepción y abrir mesa de combustibles','Protesta legal, rutas abiertas y un cronograma público de abastecimiento. La excepción no puede ser el plan económico.',1,5000,1260,'2026-09-19 17:31:24','open','2026-08-17 17:31:24','2026-08-22 17:31:24');
/*!40000 ALTER TABLE `vote_topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'politica'
--

--
-- Dumping routines for database 'politica'
--

--
-- Current Database: `militancia`
--

/*!40000 DROP DATABASE IF EXISTS `militancia`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `militancia` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `militancia`;

--
-- Table structure for table `militants`
--

DROP TABLE IF EXISTS `militants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `militants` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `full_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ci` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `department` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `birth_year` smallint unsigned NOT NULL,
  `consent` tinyint(1) NOT NULL DEFAULT '1',
  `card_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `militants_ci_unique` (`ci`),
  UNIQUE KEY `militants_email_unique` (`email`),
  UNIQUE KEY `militants_card_number_unique` (`card_number`),
  KEY `militants_department_city_index` (`department`,`city`),
  KEY `militants_status_index` (`status`),
  KEY `militants_user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `militants`
--

LOCK TABLES `militants` WRITE;
/*!40000 ALTER TABLE `militants` DISABLE KEYS */;
/*!40000 ALTER TABLE `militants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'militancia'
--

--
-- Dumping routines for database 'militancia'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-15 16:36:02
