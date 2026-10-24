-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: orbital_health
-- ------------------------------------------------------
-- Server version	8.0.45

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
-- Table structure for table `admissions`
--

DROP TABLE IF EXISTS `admissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admissions` (
  `admission_id` bigint NOT NULL AUTO_INCREMENT,
  `patient_id` bigint NOT NULL,
  `facility_id` int NOT NULL,
  `dept_id` int NOT NULL,
  `attending_provider_id` int NOT NULL,
  `admission_type` varchar(20) DEFAULT NULL,
  `admission_dt` datetime NOT NULL,
  `discharge_dt` datetime DEFAULT NULL,
  `drg_code` char(3) DEFAULT NULL,
  `drg_weight` decimal(6,4) DEFAULT NULL,
  `chief_complaint` varchar(500) DEFAULT NULL,
  `is_readmission` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`admission_id`),
  KEY `patient_id` (`patient_id`),
  KEY `facility_id` (`facility_id`),
  KEY `dept_id` (`dept_id`),
  KEY `attending_provider_id` (`attending_provider_id`),
  CONSTRAINT `admissions_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
  CONSTRAINT `admissions_ibfk_2` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`facility_id`),
  CONSTRAINT `admissions_ibfk_3` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`dept_id`),
  CONSTRAINT `admissions_ibfk_4` FOREIGN KEY (`attending_provider_id`) REFERENCES `providers` (`provider_id`),
  CONSTRAINT `admissions_chk_1` CHECK ((`admission_type` in (_utf8mb4'inpatient',_utf8mb4'outpatient',_utf8mb4'ED',_utf8mb4'observation',_utf8mb4'day_surgery')))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admissions`
--

LOCK TABLES `admissions` WRITE;
/*!40000 ALTER TABLE `admissions` DISABLE KEYS */;
INSERT INTO `admissions` VALUES (1,1,1,1,1,'ED','2026-01-10 08:30:00','2026-01-10 14:00:00','291',NULL,'Chest pain',0),(2,2,1,3,2,'inpatient','2026-02-15 10:00:00','2026-02-19 11:00:00','280',NULL,'Arrhythmia',0),(3,3,2,4,4,'outpatient','2026-03-05 09:00:00','2026-03-05 12:00:00','392',NULL,'Diabetes follow-up',0),(4,4,3,5,5,'inpatient','2026-04-01 07:00:00','2026-04-10 15:00:00','180',NULL,'Cancer treatment',0),(5,5,1,2,3,'observation','2026-05-20 22:00:00','2026-05-21 10:00:00','312',NULL,'Respiratory distress',0),(6,1,1,1,1,'ED','2026-01-10 08:30:00','2026-01-10 14:00:00','291',NULL,'Chest pain',0),(7,2,1,3,2,'inpatient','2026-02-15 10:00:00','2026-02-19 11:00:00','280',NULL,'Arrhythmia',0),(8,3,2,4,4,'outpatient','2026-03-05 09:00:00','2026-03-05 12:00:00','392',NULL,'Diabetes follow-up',0),(9,4,3,5,5,'inpatient','2026-04-01 07:00:00','2026-04-10 15:00:00','180',NULL,'Cancer treatment',0),(10,5,1,2,3,'observation','2026-05-20 22:00:00','2026-05-21 10:00:00','312',NULL,'Respiratory distress',0),(11,1,1,1,1,'ED','2026-01-10 08:30:00','2026-01-10 14:00:00','291',NULL,'Chest pain',0),(12,2,1,3,2,'inpatient','2026-02-15 10:00:00','2026-02-19 11:00:00','280',NULL,'Arrhythmia',0),(13,3,2,4,4,'outpatient','2026-03-05 09:00:00','2026-03-05 12:00:00','392',NULL,'Diabetes follow-up',0),(14,4,3,5,5,'inpatient','2026-04-01 07:00:00','2026-04-10 15:00:00','180',NULL,'Cancer treatment',0),(15,5,1,2,3,'observation','2026-05-20 22:00:00','2026-05-21 10:00:00','312',NULL,'Respiratory distress',0),(16,1,1,1,1,'ED','2026-09-01 18:00:35',NULL,NULL,NULL,'Follow up chest pain',0);
/*!40000 ALTER TABLE `admissions` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_flag_readmission` BEFORE INSERT ON `admissions` FOR EACH ROW BEGIN
    DECLARE last_discharge DATETIME;
    
    -- Check if patient was discharged 
    -- within last 30 days
    SELECT MAX(discharge_dt) 
    INTO last_discharge
    FROM admissions
    WHERE patient_id = NEW.patient_id
    AND discharge_dt IS NOT NULL;
    
    -- If yes, mark as readmission
    IF last_discharge IS NOT NULL 
    AND DATEDIFF(NEW.admission_dt, 
        last_discharge) <= 30 THEN
        SET NEW.is_readmission = 1;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `audit_trail_hipaa`
--

DROP TABLE IF EXISTS `audit_trail_hipaa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_trail_hipaa` (
  `audit_id` bigint NOT NULL AUTO_INCREMENT,
  `patient_id` bigint DEFAULT NULL,
  `accessor_user` varchar(100) NOT NULL,
  `access_reason` varchar(200) DEFAULT NULL,
  `action_type` varchar(50) DEFAULT NULL,
  `table_accessed` varchar(100) DEFAULT NULL,
  `accessed_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(45) DEFAULT NULL,
  `is_bulk_access` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`audit_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_trail_hipaa`
--

LOCK TABLES `audit_trail_hipaa` WRITE;
/*!40000 ALTER TABLE `audit_trail_hipaa` DISABLE KEYS */;
INSERT INTO `audit_trail_hipaa` VALUES (1,1,'dr.wilson','Patient admission','READ','patients','2026-09-01 17:06:40',NULL,0),(2,2,'dr.chen','Cardiology consult','READ','patients','2026-09-01 17:06:40',NULL,0),(3,3,'dr.patel','Outpatient visit','READ','patients','2026-09-01 17:06:40',NULL,0),(4,1,'dr.wilson','Patient admission','READ','patients','2026-09-01 17:07:37',NULL,0),(5,2,'dr.chen','Cardiology consult','READ','patients','2026-09-01 17:07:37',NULL,0),(6,3,'dr.patel','Outpatient visit','READ','patients','2026-09-01 17:07:37',NULL,0),(7,1,'SYSTEM_AUTO','Critical lab result detected - auto logged','CRITICAL_ALERT','lab_results','2026-09-01 18:00:14',NULL,0),(8,2,'provider_2','Prescription added: Warfarin','INSERT','prescriptions','2026-09-01 18:00:59',NULL,0);
/*!40000 ALTER TABLE `audit_trail_hipaa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clinical_trials`
--

DROP TABLE IF EXISTS `clinical_trials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clinical_trials` (
  `trial_id` int NOT NULL AUTO_INCREMENT,
  `trial_name` varchar(300) NOT NULL,
  `nct_number` varchar(20) DEFAULT NULL,
  `phase` varchar(10) DEFAULT NULL,
  `sponsor` varchar(200) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `enrollment_target` int DEFAULT NULL,
  `start_dt` date DEFAULT NULL,
  `end_dt` date DEFAULT NULL,
  PRIMARY KEY (`trial_id`),
  UNIQUE KEY `nct_number` (`nct_number`),
  CONSTRAINT `clinical_trials_chk_1` CHECK ((`phase` in (_utf8mb4'Phase1',_utf8mb4'Phase2',_utf8mb4'Phase3',_utf8mb4'Phase4'))),
  CONSTRAINT `clinical_trials_chk_2` CHECK ((`status` in (_utf8mb4'enrolling',_utf8mb4'completed',_utf8mb4'suspended',_utf8mb4'closed')))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinical_trials`
--

LOCK TABLES `clinical_trials` WRITE;
/*!40000 ALTER TABLE `clinical_trials` DISABLE KEYS */;
INSERT INTO `clinical_trials` VALUES (1,'Orbital Cardiac Recovery Study','NCT04521234','Phase3','Orbital Research Division','enrolling',500,'2025-01-01','2027-01-01'),(2,'Advanced Oncology Immunotherapy Trial','NCT04521235','Phase2','Orbital Oncology Group','enrolling',200,'2025-06-01','2026-12-01'),(3,'Neurological Recovery After Stroke','NCT04521236','Phase3','Orbital Neurology Center','enrolling',350,'2024-09-01','2026-09-01');
/*!40000 ALTER TABLE `clinical_trials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `dept_id` int NOT NULL AUTO_INCREMENT,
  `facility_id` int NOT NULL,
  `dept_name` varchar(100) NOT NULL,
  `specialty` varchar(100) DEFAULT NULL,
  `budget_code` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`dept_id`),
  KEY `facility_id` (`facility_id`),
  CONSTRAINT `departments_ibfk_1` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`facility_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,1,'Emergency Department','Emergency Medicine','ED-001'),(2,1,'ICU','Critical Care','ICU-001'),(3,1,'Cardiology','Cardiology','CARD-001'),(4,2,'Outpatient Clinic','General Medicine','OPD-001'),(5,3,'Oncology Research','Oncology','ONC-001');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diagnoses`
--

DROP TABLE IF EXISTS `diagnoses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diagnoses` (
  `diagnosis_id` bigint NOT NULL AUTO_INCREMENT,
  `admission_id` bigint NOT NULL,
  `icd10_code` varchar(10) NOT NULL,
  `diagnosis_type` varchar(20) DEFAULT NULL,
  `diagnosed_dt` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`diagnosis_id`),
  KEY `admission_id` (`admission_id`),
  CONSTRAINT `diagnoses_ibfk_1` FOREIGN KEY (`admission_id`) REFERENCES `admissions` (`admission_id`),
  CONSTRAINT `diagnoses_chk_1` CHECK ((`diagnosis_type` in (_utf8mb4'primary',_utf8mb4'secondary',_utf8mb4'comorbidity')))
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diagnoses`
--

LOCK TABLES `diagnoses` WRITE;
/*!40000 ALTER TABLE `diagnoses` DISABLE KEYS */;
INSERT INTO `diagnoses` VALUES (1,1,'I21.9','primary','2026-09-01 17:06:40'),(2,2,'I48.0','primary','2026-09-01 17:06:40'),(3,2,'E11.9','comorbidity','2026-09-01 17:06:40'),(4,3,'E11.9','primary','2026-09-01 17:06:40'),(5,4,'C34.1','primary','2026-09-01 17:06:40'),(6,5,'J96.0','primary','2026-09-01 17:06:40'),(7,1,'I21.9','primary','2026-09-01 17:07:37'),(8,2,'I48.0','primary','2026-09-01 17:07:37'),(9,2,'E11.9','comorbidity','2026-09-01 17:07:37'),(10,3,'E11.9','primary','2026-09-01 17:07:37'),(11,4,'C34.1','primary','2026-09-01 17:07:37'),(12,5,'J96.0','primary','2026-09-01 17:07:37');
/*!40000 ALTER TABLE `diagnoses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facilities`
--

DROP TABLE IF EXISTS `facilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facilities` (
  `facility_id` int NOT NULL AUTO_INCREMENT,
  `facility_name` varchar(200) NOT NULL,
  `npi_number` char(10) NOT NULL,
  `facility_type` varchar(50) DEFAULT NULL,
  `bed_count` int DEFAULT NULL,
  `trauma_level` tinyint DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` char(2) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`facility_id`),
  UNIQUE KEY `npi_number` (`npi_number`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facilities`
--

LOCK TABLES `facilities` WRITE;
/*!40000 ALTER TABLE `facilities` DISABLE KEYS */;
INSERT INTO `facilities` VALUES (1,'Orbital General Hospital','1234567890','Hospital',500,1,'New York','NY',1,'2026-06-18 21:13:55'),(2,'Orbital West Clinic','1234567891','Clinic',120,3,'Los Angeles','CA',1,'2026-06-18 21:13:55'),(3,'Orbital Research Center','1234567892','Research',80,2,'Chicago','IL',1,'2026-06-18 21:13:55');
/*!40000 ALTER TABLE `facilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `icu_telemetry`
--

DROP TABLE IF EXISTS `icu_telemetry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `icu_telemetry` (
  `telemetry_id` bigint NOT NULL AUTO_INCREMENT,
  `admission_id` bigint NOT NULL,
  `device_id` int NOT NULL,
  `recorded_at` datetime NOT NULL,
  `heart_rate` int DEFAULT NULL,
  `systolic_bp` int DEFAULT NULL,
  `diastolic_bp` int DEFAULT NULL,
  `spo2` decimal(5,2) DEFAULT NULL,
  `temperature` decimal(5,2) DEFAULT NULL,
  `is_ventilated` tinyint(1) DEFAULT '0',
  `alert_flag` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`telemetry_id`),
  KEY `admission_id` (`admission_id`),
  CONSTRAINT `icu_telemetry_ibfk_1` FOREIGN KEY (`admission_id`) REFERENCES `admissions` (`admission_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `icu_telemetry`
--

LOCK TABLES `icu_telemetry` WRITE;
/*!40000 ALTER TABLE `icu_telemetry` DISABLE KEYS */;
INSERT INTO `icu_telemetry` VALUES (1,5,101,'2026-05-20 22:00:00',118,88,55,88.50,38.90,1,1),(2,5,101,'2026-05-20 23:00:00',105,95,62,91.00,38.50,1,1),(3,5,101,'2026-05-21 00:00:00',98,102,68,94.00,38.10,1,0),(4,2,102,'2026-02-15 10:00:00',140,145,90,96.00,37.20,0,1),(5,5,101,'2026-05-20 22:00:00',118,88,55,88.50,38.90,1,1),(6,5,101,'2026-05-20 23:00:00',105,95,62,91.00,38.50,1,1),(7,5,101,'2026-05-21 00:00:00',98,102,68,94.00,38.10,1,0),(8,2,102,'2026-02-15 10:00:00',140,145,90,96.00,37.20,0,1);
/*!40000 ALTER TABLE `icu_telemetry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `imaging_studies`
--

DROP TABLE IF EXISTS `imaging_studies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `imaging_studies` (
  `imaging_id` bigint NOT NULL AUTO_INCREMENT,
  `patient_id` bigint NOT NULL,
  `admission_id` bigint NOT NULL,
  `modality` varchar(50) DEFAULT NULL,
  `body_part` varchar(100) DEFAULT NULL,
  `urgency` varchar(20) DEFAULT NULL,
  `ordered_dt` datetime DEFAULT NULL,
  `completed_dt` datetime DEFAULT NULL,
  `radiologist_id` int DEFAULT NULL,
  `findings` text,
  PRIMARY KEY (`imaging_id`),
  KEY `patient_id` (`patient_id`),
  KEY `admission_id` (`admission_id`),
  CONSTRAINT `imaging_studies_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
  CONSTRAINT `imaging_studies_ibfk_2` FOREIGN KEY (`admission_id`) REFERENCES `admissions` (`admission_id`),
  CONSTRAINT `imaging_studies_chk_1` CHECK ((`urgency` in (_utf8mb4'routine',_utf8mb4'urgent',_utf8mb4'stat')))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imaging_studies`
--

LOCK TABLES `imaging_studies` WRITE;
/*!40000 ALTER TABLE `imaging_studies` DISABLE KEYS */;
INSERT INTO `imaging_studies` VALUES (1,1,1,'ECG','Heart','stat','2026-01-10 08:45:00','2026-01-10 09:15:00',NULL,'ST elevation noted'),(2,2,2,'Echo','Heart','urgent','2026-02-15 10:30:00','2026-02-15 12:00:00',NULL,'Atrial fibrillation confirmed'),(3,4,4,'CT','Chest','routine','2026-04-01 08:00:00','2026-04-01 10:00:00',NULL,'Tumor size reduced 15%'),(4,5,5,'Xray','Chest','stat','2026-05-20 22:15:00','2026-05-20 22:45:00',NULL,'Bilateral infiltrates'),(5,1,1,'ECG','Heart','stat','2026-01-10 08:45:00','2026-01-10 09:15:00',NULL,'ST elevation noted'),(6,2,2,'Echo','Heart','urgent','2026-02-15 10:30:00','2026-02-15 12:00:00',NULL,'Atrial fibrillation confirmed'),(7,4,4,'CT','Chest','routine','2026-04-01 08:00:00','2026-04-01 10:00:00',NULL,'Tumor size reduced 15%'),(8,5,5,'Xray','Chest','stat','2026-05-20 22:15:00','2026-05-20 22:45:00',NULL,'Bilateral infiltrates');
/*!40000 ALTER TABLE `imaging_studies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `insurance_claims`
--

DROP TABLE IF EXISTS `insurance_claims`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `insurance_claims` (
  `claim_id` bigint NOT NULL AUTO_INCREMENT,
  `admission_id` bigint NOT NULL,
  `payer_name` varchar(100) DEFAULT NULL,
  `billed_amount` decimal(12,2) DEFAULT NULL,
  `allowed_amount` decimal(12,2) DEFAULT NULL,
  `patient_responsibility` decimal(12,2) DEFAULT NULL,
  `claim_status` varchar(30) DEFAULT NULL,
  `denial_reason` varchar(200) DEFAULT NULL,
  `submitted_dt` datetime DEFAULT NULL,
  `resolved_dt` datetime DEFAULT NULL,
  PRIMARY KEY (`claim_id`),
  KEY `admission_id` (`admission_id`),
  CONSTRAINT `insurance_claims_ibfk_1` FOREIGN KEY (`admission_id`) REFERENCES `admissions` (`admission_id`),
  CONSTRAINT `insurance_claims_chk_1` CHECK ((`claim_status` in (_utf8mb4'submitted',_utf8mb4'approved',_utf8mb4'denied',_utf8mb4'appealed',_utf8mb4'paid')))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `insurance_claims`
--

LOCK TABLES `insurance_claims` WRITE;
/*!40000 ALTER TABLE `insurance_claims` DISABLE KEYS */;
INSERT INTO `insurance_claims` VALUES (1,1,'Medicare',4500.00,3200.00,320.00,'approved',NULL,'2026-01-11 08:00:00',NULL),(2,2,'Blue Cross',18000.00,14000.00,1400.00,'submitted',NULL,'2026-02-20 08:00:00',NULL),(3,3,'Medicaid',850.00,720.00,0.00,'paid',NULL,'2026-03-06 08:00:00',NULL),(4,4,'Aetna',45000.00,38000.00,3800.00,'submitted',NULL,'2026-04-11 08:00:00',NULL),(5,5,'Uninsured',3200.00,3200.00,3200.00,'submitted',NULL,'2026-05-21 08:00:00',NULL),(6,1,'Medicare',4500.00,3200.00,320.00,'approved',NULL,'2026-01-11 08:00:00',NULL),(7,2,'Blue Cross',18000.00,14000.00,1400.00,'submitted',NULL,'2026-02-20 08:00:00',NULL),(8,3,'Medicaid',850.00,720.00,0.00,'paid',NULL,'2026-03-06 08:00:00',NULL),(9,4,'Aetna',45000.00,38000.00,3800.00,'submitted',NULL,'2026-04-11 08:00:00',NULL),(10,5,'Uninsured',3200.00,3200.00,3200.00,'submitted',NULL,'2026-05-21 08:00:00',NULL);
/*!40000 ALTER TABLE `insurance_claims` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lab_results`
--

DROP TABLE IF EXISTS `lab_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lab_results` (
  `lab_id` bigint NOT NULL AUTO_INCREMENT,
  `patient_id` bigint NOT NULL,
  `admission_id` bigint NOT NULL,
  `loinc_code` varchar(20) NOT NULL,
  `test_name` varchar(200) DEFAULT NULL,
  `numeric_value` decimal(10,3) DEFAULT NULL,
  `unit` varchar(30) DEFAULT NULL,
  `reference_range` varchar(50) DEFAULT NULL,
  `critical_flag` tinyint(1) DEFAULT '0',
  `collected_at` datetime NOT NULL,
  `resulted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`lab_id`),
  KEY `patient_id` (`patient_id`),
  KEY `admission_id` (`admission_id`),
  CONSTRAINT `lab_results_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
  CONSTRAINT `lab_results_ibfk_2` FOREIGN KEY (`admission_id`) REFERENCES `admissions` (`admission_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lab_results`
--

LOCK TABLES `lab_results` WRITE;
/*!40000 ALTER TABLE `lab_results` DISABLE KEYS */;
INSERT INTO `lab_results` VALUES (1,1,1,'2160-0','Creatinine',1.200,'mg/dL','0.6-1.2',0,'2026-01-10 09:30:00',NULL),(2,2,2,'6598-7','Troponin I',0.850,'ng/mL','0.0-0.04',1,'2026-02-15 11:30:00',NULL),(3,3,3,'2345-7','Glucose',285.000,'mg/dL','70-100',1,'2026-03-05 09:30:00',NULL),(4,5,5,'59408-5','SpO2',88.000,'%','95-100',1,'2026-05-20 22:30:00',NULL),(5,1,1,'2160-0','Creatinine',1.200,'mg/dL','0.6-1.2',0,'2026-01-10 09:30:00',NULL),(6,2,2,'6598-7','Troponin I',0.850,'ng/mL','0.0-0.04',1,'2026-02-15 11:30:00',NULL),(7,3,3,'2345-7','Glucose',285.000,'mg/dL','70-100',1,'2026-03-05 09:30:00',NULL),(8,5,5,'59408-5','SpO2',88.000,'%','95-100',1,'2026-05-20 22:30:00',NULL),(9,1,1,'2951-2','Sodium',158.000,'mEq/L','135-145',1,'2026-09-01 18:00:14',NULL);
/*!40000 ALTER TABLE `lab_results` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_critical_lab_audit` AFTER INSERT ON `lab_results` FOR EACH ROW BEGIN
    IF NEW.critical_flag = 1 THEN
        INSERT INTO audit_trail_hipaa (
            patient_id,
            accessor_user,
            access_reason,
            action_type,
            table_accessed,
            accessed_at
        )
        VALUES (
            NEW.patient_id,
            'SYSTEM_AUTO',
            'Critical lab result detected - auto logged',
            'CRITICAL_ALERT',
            'lab_results',
            NOW()
        );
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `patients`
--

DROP TABLE IF EXISTS `patients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patients` (
  `patient_id` bigint NOT NULL AUTO_INCREMENT,
  `mrn` varchar(20) NOT NULL,
  `gender` char(1) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `blood_type` char(3) DEFAULT NULL,
  `insurance_type` varchar(30) DEFAULT NULL,
  `primary_facility_id` int DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`patient_id`),
  UNIQUE KEY `mrn` (`mrn`),
  KEY `primary_facility_id` (`primary_facility_id`),
  CONSTRAINT `patients_ibfk_1` FOREIGN KEY (`primary_facility_id`) REFERENCES `facilities` (`facility_id`),
  CONSTRAINT `patients_chk_1` CHECK ((`gender` in (_utf8mb4'M',_utf8mb4'F',_utf8mb4'X',_utf8mb4'U')))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` VALUES (1,'MRN-00001','M','1975-03-15','O+','Medicare',1,1,'2026-06-18 21:13:56'),(2,'MRN-00002','F','1988-07-22','A+','Commercial',1,1,'2026-06-18 21:13:56'),(3,'MRN-00003','F','1952-11-08','B-','Medicaid',2,1,'2026-06-18 21:13:56'),(4,'MRN-00004','M','2001-01-30','AB+','Commercial',3,1,'2026-06-18 21:13:56'),(5,'MRN-00005','X','1965-09-17','O-','Uninsured',1,1,'2026-06-18 21:13:56');
/*!40000 ALTER TABLE `patients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescriptions`
--

DROP TABLE IF EXISTS `prescriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescriptions` (
  `prescription_id` bigint NOT NULL AUTO_INCREMENT,
  `patient_id` bigint NOT NULL,
  `admission_id` bigint NOT NULL,
  `prescribing_provider_id` int NOT NULL,
  `ndc_code` char(11) NOT NULL,
  `drug_name` varchar(200) DEFAULT NULL,
  `dose_amount` decimal(10,3) DEFAULT NULL,
  `dose_unit` varchar(20) DEFAULT NULL,
  `route` varchar(30) DEFAULT NULL,
  `frequency` varchar(50) DEFAULT NULL,
  `days_supply` int DEFAULT NULL,
  `is_controlled` tinyint(1) DEFAULT '0',
  `prescribed_dt` datetime NOT NULL,
  PRIMARY KEY (`prescription_id`),
  KEY `patient_id` (`patient_id`),
  KEY `admission_id` (`admission_id`),
  KEY `prescribing_provider_id` (`prescribing_provider_id`),
  CONSTRAINT `prescriptions_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
  CONSTRAINT `prescriptions_ibfk_2` FOREIGN KEY (`admission_id`) REFERENCES `admissions` (`admission_id`),
  CONSTRAINT `prescriptions_ibfk_3` FOREIGN KEY (`prescribing_provider_id`) REFERENCES `providers` (`provider_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescriptions`
--

LOCK TABLES `prescriptions` WRITE;
/*!40000 ALTER TABLE `prescriptions` DISABLE KEYS */;
INSERT INTO `prescriptions` VALUES (1,1,1,1,'00071015423','Aspirin',81.000,'mg','oral',NULL,30,0,'2026-01-10 09:00:00'),(2,2,2,2,'00078045215','Metoprolol',25.000,'mg','oral',NULL,60,0,'2026-02-15 11:00:00'),(3,4,4,5,'00069306030','Carboplatin',450.000,'mg','IV',NULL,7,0,'2026-04-01 08:00:00'),(4,5,5,3,'00517390425','Albuterol',2.500,'mg','nebulizer',NULL,14,0,'2026-05-20 23:00:00'),(5,1,1,1,'00071015423','Aspirin',81.000,'mg','oral',NULL,30,0,'2026-01-10 09:00:00'),(6,2,2,2,'00078045215','Metoprolol',25.000,'mg','oral',NULL,60,0,'2026-02-15 11:00:00'),(7,4,4,5,'00069306030','Carboplatin',450.000,'mg','IV',NULL,7,0,'2026-04-01 08:00:00'),(8,5,5,3,'00517390425','Albuterol',2.500,'mg','nebulizer',NULL,14,0,'2026-05-20 23:00:00'),(9,2,2,2,'00071015424','Warfarin',5.000,'mg','oral',NULL,90,0,'2026-09-01 18:00:59');
/*!40000 ALTER TABLE `prescriptions` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_prescription_audit` AFTER INSERT ON `prescriptions` FOR EACH ROW BEGIN
    INSERT INTO audit_trail_hipaa (
        patient_id,
        accessor_user,
        access_reason,
        action_type,
        table_accessed,
        accessed_at
    )
    VALUES (
        NEW.patient_id,
        CONCAT('provider_', 
            NEW.prescribing_provider_id),
        CONCAT('Prescription added: ', 
            NEW.drug_name),
        'INSERT',
        'prescriptions',
        NOW()
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `procedures_performed`
--

DROP TABLE IF EXISTS `procedures_performed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `procedures_performed` (
  `procedure_id` bigint NOT NULL AUTO_INCREMENT,
  `admission_id` bigint NOT NULL,
  `patient_id` bigint NOT NULL,
  `provider_id` int NOT NULL,
  `cpt_code` varchar(10) NOT NULL,
  `procedure_name` varchar(200) DEFAULT NULL,
  `duration_minutes` int DEFAULT NULL,
  `outcome` varchar(50) DEFAULT NULL,
  `complication_flag` tinyint(1) DEFAULT '0',
  `performed_dt` datetime NOT NULL,
  PRIMARY KEY (`procedure_id`),
  KEY `admission_id` (`admission_id`),
  KEY `patient_id` (`patient_id`),
  KEY `provider_id` (`provider_id`),
  CONSTRAINT `procedures_performed_ibfk_1` FOREIGN KEY (`admission_id`) REFERENCES `admissions` (`admission_id`),
  CONSTRAINT `procedures_performed_ibfk_2` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
  CONSTRAINT `procedures_performed_ibfk_3` FOREIGN KEY (`provider_id`) REFERENCES `providers` (`provider_id`),
  CONSTRAINT `procedures_performed_chk_1` CHECK ((`outcome` in (_utf8mb4'successful',_utf8mb4'complicated',_utf8mb4'failed',_utf8mb4'abandoned')))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procedures_performed`
--

LOCK TABLES `procedures_performed` WRITE;
/*!40000 ALTER TABLE `procedures_performed` DISABLE KEYS */;
INSERT INTO `procedures_performed` VALUES (1,1,1,1,'92950','Cardiopulmonary Resuscitation',30,'successful',0,'2026-01-10 09:00:00'),(2,2,2,2,'93000','Electrocardiogram',15,'successful',0,'2026-02-15 11:00:00'),(3,4,4,5,'96413','Chemotherapy Administration',180,'successful',0,'2026-04-01 09:00:00'),(4,5,5,3,'94002','Ventilator Management',60,'successful',0,'2026-05-20 23:30:00'),(5,1,1,1,'92950','Cardiopulmonary Resuscitation',30,'successful',0,'2026-01-10 09:00:00'),(6,2,2,2,'93000','Electrocardiogram',15,'successful',0,'2026-02-15 11:00:00'),(7,4,4,5,'96413','Chemotherapy Administration',180,'successful',0,'2026-04-01 09:00:00'),(8,5,5,3,'94002','Ventilator Management',60,'successful',0,'2026-05-20 23:30:00');
/*!40000 ALTER TABLE `procedures_performed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `providers`
--

DROP TABLE IF EXISTS `providers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `providers` (
  `provider_id` int NOT NULL AUTO_INCREMENT,
  `facility_id` int NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `npi_number` char(10) DEFAULT NULL,
  `dea_number` varchar(20) DEFAULT NULL,
  `specialty` varchar(100) DEFAULT NULL,
  `license_state` char(2) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`provider_id`),
  UNIQUE KEY `npi_number` (`npi_number`),
  KEY `facility_id` (`facility_id`),
  CONSTRAINT `providers_ibfk_1` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`facility_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `providers`
--

LOCK TABLES `providers` WRITE;
/*!40000 ALTER TABLE `providers` DISABLE KEYS */;
INSERT INTO `providers` VALUES (1,1,'James','Wilson','9876543210',NULL,'Emergency Medicine','NY',1),(2,1,'Sarah','Chen','9876543211',NULL,'Cardiology','NY',1),(3,1,'Michael','Torres','9876543212',NULL,'Critical Care','NY',1),(4,2,'Emily','Patel','9876543213',NULL,'General Medicine','CA',1),(5,3,'David','Kim','9876543214',NULL,'Oncology','IL',1);
/*!40000 ALTER TABLE `providers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trial_enrollments`
--

DROP TABLE IF EXISTS `trial_enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trial_enrollments` (
  `enrollment_id` bigint NOT NULL AUTO_INCREMENT,
  `patient_id` bigint NOT NULL,
  `trial_id` int NOT NULL,
  `arm` varchar(50) DEFAULT NULL,
  `enrolling_provider` int NOT NULL,
  `consent_date` date NOT NULL,
  `enrollment_dt` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) DEFAULT 'active',
  PRIMARY KEY (`enrollment_id`),
  KEY `patient_id` (`patient_id`),
  KEY `trial_id` (`trial_id`),
  KEY `enrolling_provider` (`enrolling_provider`),
  CONSTRAINT `trial_enrollments_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
  CONSTRAINT `trial_enrollments_ibfk_2` FOREIGN KEY (`trial_id`) REFERENCES `clinical_trials` (`trial_id`),
  CONSTRAINT `trial_enrollments_ibfk_3` FOREIGN KEY (`enrolling_provider`) REFERENCES `providers` (`provider_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trial_enrollments`
--

LOCK TABLES `trial_enrollments` WRITE;
/*!40000 ALTER TABLE `trial_enrollments` DISABLE KEYS */;
INSERT INTO `trial_enrollments` VALUES (1,2,1,'Treatment',2,'2026-02-01','2026-06-20 04:43:25','active'),(2,4,2,'Control',5,'2026-03-15','2026-06-20 04:43:25','active'),(3,1,3,'Treatment',1,'2026-04-10','2026-06-20 04:43:25','active'),(4,2,1,'Treatment',2,'2026-02-01','2026-06-20 04:47:15','active'),(5,4,2,'Control',5,'2026-03-15','2026-06-20 04:47:15','active'),(6,1,3,'Treatment',1,'2026-04-10','2026-06-20 04:47:15','active');
/*!40000 ALTER TABLE `trial_enrollments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'orbital_health'
--
/*!50003 DROP PROCEDURE IF EXISTS `GetCriticalPatientAlerts` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCriticalPatientAlerts`()
BEGIN
    SELECT 
        p.mrn,
        p.gender,
        f.facility_name,
        d.dept_name,
        CONCAT(pr.first_name,' ',pr.last_name) 
            AS attending_doctor,
        l.test_name,
        l.numeric_value,
        l.unit,
        l.reference_range,
        l.collected_at,
        '🚨 CRITICAL RESULT' AS alert_status
    FROM lab_results l
    JOIN patients p ON l.patient_id = p.patient_id
    JOIN admissions a 
        ON l.admission_id = a.admission_id
    JOIN facilities f 
        ON a.facility_id = f.facility_id
    JOIN departments d 
        ON a.dept_id = d.dept_id
    JOIN providers pr 
        ON a.attending_provider_id = pr.provider_id
    WHERE l.critical_flag = 1
    ORDER BY l.collected_at DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetFacilityRevenueReport` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetFacilityRevenueReport`(
    IN input_facility_id INT
)
BEGIN
    SELECT
        f.facility_name,
        f.facility_type,
        f.city,
        f.state,
        COUNT(a.admission_id) AS total_admissions,
        SUM(ic.billed_amount) AS total_billed,
        SUM(ic.allowed_amount) AS total_collected,
        SUM(ic.billed_amount - ic.allowed_amount) 
            AS total_written_off,
        ROUND(AVG(ic.billed_amount), 2) 
            AS avg_bill_per_admission,
        SUM(CASE WHEN ic.claim_status = 'denied' 
            THEN 1 ELSE 0 END) AS denied_claims
    FROM facilities f
    LEFT JOIN admissions a 
        ON f.facility_id = a.facility_id
    LEFT JOIN insurance_claims ic 
        ON a.admission_id = ic.admission_id
    WHERE f.facility_id = input_facility_id
    GROUP BY f.facility_id, f.facility_name, 
        f.facility_type, f.city, f.state;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetPatientAdmissionHistory` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPatientAdmissionHistory`(
    IN input_patient_id BIGINT
)
BEGIN
    SELECT 
        p.mrn,
        p.gender,
        p.insurance_type,
        a.admission_type,
        a.admission_dt,
        a.discharge_dt,
        TIMESTAMPDIFF(HOUR, 
            a.admission_dt, a.discharge_dt) 
            AS hours_stayed,
        d.icd10_code,
        d.diagnosis_type,
        ic.billed_amount,
        ic.claim_status,
        CONCAT(pr.first_name,' ',pr.last_name) 
            AS attending_doctor
    FROM patients p
    JOIN admissions a 
        ON p.patient_id = a.patient_id
    LEFT JOIN diagnoses d 
        ON a.admission_id = d.admission_id
    LEFT JOIN insurance_claims ic 
        ON a.admission_id = ic.admission_id
    JOIN providers pr 
        ON a.attending_provider_id = pr.provider_id
    WHERE p.patient_id = input_patient_id
    ORDER BY a.admission_dt DESC;
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

-- Dump completed on 2026-10-04 12:43:42
