## 📊 Healthcare RCM Data Lake on GCP
----------------------------------------
This project demonstrates an end-to-end data engineering solution for building a scalable Data Lake on Google Cloud Platform (GCP) focused on Revenue Cycle Management (RCM) in the healthcare domain.

### 🚀 Objective
To centralize, process, and analyze healthcare data from multiple sources, enabling efficient billing, claims processing, and revenue tracking.

### 🛠️ Tech Stack
- Google Cloud Storage (GCS) – Data Lake (raw & processed data)
- BigQuery – Data Warehouse for analytics
- Dataproc (Apache Spark) – Large-scale data processing
- Cloud Composer (Airflow) – Workflow orchestration
- Cloud SQL (MySQL) – Transactional data storage
- GitHub & Cloud Build – Version control and CI/CD

### ⚙️ Key Features
- End-to-end ETL pipeline
- Medallion Architecture (Bronze, Silver, Gold layers)
- Metadata-driven pipeline design
- SCD Type 2 implementation
- Data validation, logging & monitoring
- Error handling and performance optimization

### 📂 Data Sources
- EMR (Electronic Medical Records)
- Claims data
- CPT codes
- NPI data

### 📈 Outcomes
- Automated data ingestion and transformation
- Structured data warehouse in BigQuery
- KPI dashboards for business insights
