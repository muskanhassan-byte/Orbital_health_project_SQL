# 🏥 Orbital Health Systems — Healthcare Database Management & Analytics

## 📌 Project Overview

**Orbital Health Systems** is an enterprise-style healthcare database project developed using **MySQL 8.0**. It demonstrates relational database design, healthcare data management, SQL programming, and business intelligence through practical healthcare scenarios.

The project models interconnected healthcare operations, including patient management, clinical workflows, ICU telemetry, clinical trials, insurance claims processing, and healthcare data privacy.

It showcases the use of SQL to organize complex data, automate database operations, and generate meaningful insights to support business and operational decision-making.

## 🎯 Project Objectives

- Design a structured relational database for healthcare operations.
- Establish relationships between interconnected healthcare entities.
- Write SQL queries to answer business and operational questions.
- Automate repetitive database tasks using stored procedures and triggers.
- Create analytical views to simplify reporting and data analysis.
- Demonstrate awareness of healthcare data privacy and compliance requirements.

## 🛠️ Technology Stack

- **Database:** MySQL 8.0
- **Query Language:** SQL
- **Database Concepts:** Relational Modeling, Primary Keys, Foreign Keys, Constraints, and Joins
- **Advanced SQL:** Stored Procedures, Triggers, Views, and Analytical Queries
- **Business Applications:** Healthcare Reporting, Claims Analysis, Patient Management, and Operational Analytics

## 🗂️ Database Features

The project is designed around the following components:

| Component | Quantity | Purpose |
|---|---:|---|
| Interconnected Tables | 17 | Organize healthcare data and relationships |
| Business Intelligence Queries | 10 | Answer analytical and operational questions |
| Stored Procedures | 3 | Execute reusable database operations |
| Automated Triggers | 3 | Enforce or automate selected database actions |
| Analytical Views | 5 | Simplify reporting and data retrieval |

*Counts reflect the project design and should be verified against the final SQL backup.*

## 🏥 Key Business Areas

### 1. Patient Management
Organizes patient-related information and supports the management of healthcare records.

### 2. ICU Telemetry
Models intensive care monitoring data to support analysis of patient-monitoring information.

### 3. Clinical Trials
Represents clinical research data and related trial-management activities.

### 4. Insurance Claims Processing
Supports the organization and analysis of insurance claims and associated healthcare transactions.

### 5. Healthcare Data Privacy
Includes a healthcare privacy and compliance focus, with consideration for HIPAA-related requirements.

**Note:** A database project can demonstrate privacy-aware design, but it should not be described as HIPAA-compliant or certified without a formal assessment of the applicable technical, administrative, and organizational safeguards.

## 📊 SQL Skills Demonstrated

This project provides practical exposure to:

- Database creation and schema design
- Table relationships and referential integrity
- Primary and foreign keys
- Data retrieval using `SELECT`
- Filtering, sorting, and aggregating data
- Multi-table joins
- Business-oriented analytical queries
- Stored procedures
- Database triggers
- SQL views
- Healthcare data organization and reporting

## 💼 Business Analyst Perspective

This project also demonstrates skills relevant to Business Analyst roles:

- **Business domain understanding:** Translating healthcare operations into structured data entities.
- **Data analysis:** Using SQL to answer business questions and identify operational insights.
- **Process understanding:** Representing workflows involving patients, clinical activities, and insurance claims.
- **Reporting:** Organizing information into reusable analytical views.
- **Problem-solving:** Applying structured queries to investigate business scenarios.
- **Documentation:** Presenting the purpose, structure, and functionality of a database solution.

## 📁 Project Files

| File | Description |
|---|---|
| `Dump20261004.sql` | SQL database backup containing the project schema and any included database objects or data |
| `README.md` | Project overview, technology stack, database features, and documentation |

## 🚀 How to Run the Project

### Prerequisites
- MySQL Server 8.0
- MySQL Workbench or another compatible MySQL client
- The `Dump20261004.sql` database backup

### Setup Instructions

1. Download or clone this repository to your computer.
2. Open MySQL Workbench and connect to your MySQL server.
3. Review the SQL backup before execution, particularly any database creation, deletion, or data-modification statements.
4. Import the SQL backup using MySQL Workbench's data import functionality, or execute it using an appropriate MySQL client.
5. Refresh the schema list and verify that the database objects were created successfully.
6. Test the queries, stored procedures, triggers, and views included in the backup.

**Important:** The exact import process may vary depending on how the SQL backup was generated and whether it includes database creation statements.

## 🔐 Data Privacy and Security

Healthcare information can be highly sensitive. This project should use synthetic, anonymized, or otherwise authorized data.

Before sharing the repository publicly, review the SQL backup for real patient information, names, contact details, medical records, credentials, access tokens, or other confidential information. Remove sensitive material before publication.

## 🔮 Potential Future Enhancements

- Add an entity-relationship diagram (ERD).
- Document each table, its purpose, and its relationships.
- Explain each analytical query with a business question and expected outcome.
- Add sample reports and business intelligence dashboards.
- Include test cases for stored procedures and triggers.
- Add data-quality checks and database performance improvements.

## 👩‍💻 Author

**Muskan Hassan**

Aspiring Business Analyst | SQL | Business Process Analysis | Data-Driven Decision-Making

## ⭐ Conclusion

Orbital Health Systems demonstrates how relational database design and SQL can support healthcare data management and operational analysis. The project brings together core SQL concepts and advanced database objects in a practical, business-oriented scenario.

If you find this project useful, feel free to explore the repository and review its SQL implementation.
