from pyspark.sql import SparkSession
from pyspark.sql.functions import current_timestamp

# =============================================
# Spark Session
# =============================================
#==========================================
#spark reay command
#===============================
#=======================
#patients data to be saved
#=========================
#________________________________________________
#koiejeopijreipr4iewjhjfje
#kjbfufteubwejfeu
#lwbukefyerbroi3y83uokwn32ikuy

spark = SparkSession.builder 
    .appName("hospital_claims_bronze_etl") \
    .getOrCreate()

# =============================================
# Configuration
# =============================================

PROJECT_ID = "hospital-project1-494408"
BQ_DATASET = "bronze_dataset"
TEMP_BUCKET = "hospital-rcm-landing"

# =============================================
# HOSPITAL A - CLAIMS
# =============================================

claims_ha = spark.read.csv(
    "gs://hospital-rcm-landing/landing/claims/hospital1_claim_data.csv",
    header=True,
    inferSchema=True
)

# Add audit column
claims_ha = claims_ha.withColumn("ingestion_ts", current_timestamp())

claims_ha.write.format("bigquery") \
    .option("table", f"{PROJECT_ID}.{BQ_DATASET}.claims_ha") \
    .option("temporaryGcsBucket", TEMP_BUCKET) \
    .mode("overwrite") \
    .save()

print("✅ Hospital A Claims loaded successfully")

# =============================================
# HOSPITAL B - CLAIMS
# =============================================

claims_hb = spark.read.csv(
    "gs://hospital-rcm-landing/landing/claims/hospital2_claim_data.csv",
    header=True,
    inferSchema=True
)

# Add audit column
claims_hb = claims_hb.withColumn("ingestion_ts", current_timestamp())

claims_hb.write.format("bigquery") \
    .option("table", f"{PROJECT_ID}.{BQ_DATASET}.claims_hb") \
    .option("temporaryGcsBucket", TEMP_BUCKET) \
    .mode("overwrite") \
    .save()

print("✅ Hospital B Claims loaded successfully")

# =============================================
# Job Completion
# =============================================

print("✅✅ Claims Bronze ETL Completed Successfully ✅✅")