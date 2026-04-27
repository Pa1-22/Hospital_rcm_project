from pyspark.sql import SparkSession

spark = SparkSession.builder \
.appName("hospital_bronze_etl") \
.getOrCreate()






# =========================
# HOSPITAL A TABLES
# =========================

patients_ha = spark.read.csv(
"gs://hospital-rcm-landing/landing/hospital_a/patients.csv",
header=True, inferSchema=True
)

patients_ha.write.format("bigquery") \
.option("table","hospital-project1-494408.bronze_dataset.patients_ha") \
.option("temporaryGcsBucket","hospital-rcm-landing") \
.mode("overwrite").save()


providers_ha = spark.read.csv(
"gs://hospital-rcm-landing/landing/hospital_a/providers.csv",
header=True, inferSchema=True
)

providers_ha.write.format("bigquery") \
.option("table","hospital-project1-494408.bronze_dataset.providers_ha") \
.option("temporaryGcsBucket","hospital-rcm-landing") \
.mode("overwrite").save()


departments_ha = spark.read.csv(
"gs://hospital-rcm-landing/landing/hospital_a/departments.csv",
header=True, inferSchema=True
)

departments_ha.write.format("bigquery") \
.option("table","hospital-project1-494408.bronze_dataset.departments_ha") \
.option("temporaryGcsBucket","hospital-rcm-landing") \
.mode("overwrite").save()


transactions_ha = spark.read.csv(
"gs://hospital-rcm-landing/landing/hospital_a/transactions.csv",
header=True, inferSchema=True
)

transactions_ha.write.format("bigquery") \
.option("table","hospital-project1-494408.bronze_dataset.transactions_ha") \
.option("temporaryGcsBucket","hospital-rcm-landing") \
.mode("overwrite").save()


encounters_ha = spark.read.csv(
"gs://hospital-rcm-landing/landing/hospital_a/encounters.csv",
header=True, inferSchema=True
)

encounters_ha.write.format("bigquery") \
.option("table","hospital-project1-494408.bronze_dataset.encounters_ha") \
.option("temporaryGcsBucket","hospital-rcm-landing") \
.mode("overwrite").save()



# =========================
# HOSPITAL B TABLES
# =========================

patients_hb = spark.read.csv(
"gs://hospital-rcm-landing/landing/hospital_b/patients.csv",
header=True, inferSchema=True
)

patients_hb.write.format("bigquery") \
.option("table","hospital-project1-494408.bronze_dataset.patients_hb") \
.option("temporaryGcsBucket","hospital-rcm-landing") \
.mode("overwrite").save()


providers_hb = spark.read.csv(
"gs://hospital-rcm-landing/landing/hospital_b/providers.csv",
header=True, inferSchema=True
)

providers_hb.write.format("bigquery") \
.option("table","hospital-project1-494408.bronze_dataset.providers_hb") \
.option("temporaryGcsBucket","hospital-rcm-landing") \
.mode("overwrite").save()


departments_hb = spark.read.csv(
"gs://hospital-rcm-landing/landing/hospital_b/departments.csv",
header=True, inferSchema=True
)

departments_hb.write.format("bigquery") \
.option("table","hospital-project1-494408.bronze_dataset.departments_hb") \
.option("temporaryGcsBucket","hospital-rcm-landing") \
.mode("overwrite").save()


transactions_hb = spark.read.csv(
"gs://hospital-rcm-landing/landing/hospital_b/transactions.csv",
header=True, inferSchema=True
)

transactions_hb.write.format("bigquery") \
.option("table","hospital-project1-494408.bronze_dataset.transactions_hb") \
.option("temporaryGcsBucket","hospital-rcm-landing") \
.mode("overwrite").save()


encounters_hb = spark.read.csv(
"gs://hospital-rcm-landing/landing/hospital_b/encounters.csv",
header=True, inferSchema=True
)

encounters_hb.write.format("bigquery") \
.option("table","hospital-project1-494408.bronze_dataset.encounters_hb") \
.option("temporaryGcsBucket","hospital-rcm-landing") \
.mode("overwrite").save()


print("Bronze ETL Completed Successfully")