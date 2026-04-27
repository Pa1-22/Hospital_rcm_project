/*CREATE TABLE IF NOT EXISTS `hospital-project1-494408.gold_dataset.provider_charge_summary` (
 Provider_Name STRING,
 Dept_Name STRING,
 Amount FLOAT64
);

TRUNCATE TABLE `hospital-project1-494408.gold_dataset.provider_charge_summary`;

INSERT INTO `hospital-project1-494408.gold_dataset.provider_charge_summary`
SELECT
 CONCAT(p.FirstName,' ',p.LastName) AS Provider_Name,
 d.Name AS Dept_Name,
 SUM(t.Amount) AS Amount
FROM `hospital-project1-494408.silver_dataset.transactions` t
LEFT JOIN `hospital-project1-494408.silver_dataset.providers` p
 ON SPLIT(p.ProviderID,'-')[SAFE_OFFSET(1)] = t.ProviderID
LEFT JOIN `hospital-project1-494408.silver_dataset.departments` d
 ON SPLIT(d.Dept_Id,'-')[SAFE_OFFSET(0)] = p.DeptID
WHERE t.is_quarantined = FALSE
AND d.Name IS NOT NULL
GROUP BY Provider_Name, Dept_Name;

select * from  `hospital-project1-494408.gold_dataset.provider_charge_summary` limit 10;


-----------------------------------------------2) Patient History (datatype issues fixed)----------------------------------------------------------------

CREATE OR REPLACE TABLE `hospital-project1-494408.gold_dataset.patient_history`(
Patient_Key STRING,
FirstName STRING,
LastName STRING,
Gender STRING,
DOB DATE,
Address STRING,
EncounterDate DATE,
EncounterType STRING,
Transaction_Key STRING,
VisitDate DATE,
ServiceDate DATE,
BilledAmount FLOAT64,
PaidAmount FLOAT64,
ClaimStatus STRING,
ClaimAmount FLOAT64,
ClaimPaidAmount FLOAT64,
PayorType STRING
);

INSERT INTO `hospital-project1-494408.gold_dataset.patient_history`
SELECT
p.Patient_Key,
p.FirstName,
p.LastName,
p.Gender,
p.DOB,
p.Address,
CAST(e.EncounterDate AS DATE),
e.EncounterType,
t.Transaction_Key,
SAFE_CAST(t.VisitDate AS DATE),
SAFE_CAST(t.ServiceDate AS DATE),
t.Amount,
t.PaidAmount,
c.ClaimStatus,
CAST(c.ClaimAmount AS FLOAT64),
CAST(c.PaidAmount AS FLOAT64),
c.PayorType

FROM `hospital-project1-494408.silver_dataset.patients` p

LEFT JOIN `hospital-project1-494408.silver_dataset.encounters` e
ON SPLIT(p.Patient_Key,'-')[OFFSET(0)]||'-'||SPLIT(p.Patient_Key,'-')[OFFSET(1)] = e.PatientID

LEFT JOIN `hospital-project1-494408.silver_dataset.transactions` t
ON SPLIT(p.Patient_Key,'-')[OFFSET(0)]||'-'||SPLIT(p.Patient_Key,'-')[OFFSET(1)] = t.PatientID

LEFT JOIN `hospital-project1-494408.silver_dataset.claims` c
ON t.SRC_TransactionID = c.TransactionID

WHERE p.is_current=TRUE;

select * from  `hospital-project1-494408.gold_dataset.patient_history`limit 10;


-----------------------------------------------Provider Performance-------------------------------------------------



CREATE TABLE IF NOT EXISTS `hospital-project1-494408.gold_dataset.provider_performance`(
ProviderID STRING,
FirstName STRING,
LastName STRING,
Specialization STRING,
TotalEncounters INT64,
TotalTransactions INT64,
TotalBilledAmount FLOAT64,
TotalPaidAmount FLOAT64,
ApprovedClaims INT64,
TotalClaims INT64,
ClaimApprovalRate FLOAT64
);

TRUNCATE TABLE `hospital-project1-494408.gold_dataset.provider_performance`;

INSERT INTO `hospital-project1-494408.gold_dataset.provider_performance`
SELECT
pr.ProviderID,
pr.FirstName,
pr.LastName,
pr.Specialization,
COUNT(DISTINCT e.Encounter_Key),
COUNT(DISTINCT t.Transaction_Key),
SUM(t.Amount),
SUM(t.PaidAmount),
COUNT(DISTINCT CASE WHEN c.ClaimStatus='Approved' THEN c.Claim_Key END),
COUNT(DISTINCT c.Claim_Key),
ROUND(
(COUNT(DISTINCT CASE WHEN c.ClaimStatus='Approved' THEN c.Claim_Key END) /
NULLIF(COUNT(DISTINCT c.Claim_Key),0))*100,2
)
FROM `hospital-project1-494408.silver_dataset.providers` pr
LEFT JOIN `hospital-project1-494408.silver_dataset.encounters` e
ON SPLIT(pr.ProviderID,'-')[SAFE_OFFSET(1)] = e.ProviderID
LEFT JOIN `hospital-project1-494408.silver_dataset.transactions` t
ON SPLIT(pr.ProviderID,'-')[SAFE_OFFSET(1)] = t.ProviderID
LEFT JOIN `hospital-project1-494408.silver_dataset.claims` c
ON t.SRC_TransactionID = c.TransactionID
GROUP BY
pr.ProviderID,
pr.FirstName,
pr.LastName,
pr.Specialization;


select * from `hospital-project1-494408.gold_dataset.provider_performance`limit 10;


--------------------------------------------4) Department Performance----------------------------------------------------


CREATE TABLE IF NOT EXISTS `hospital-project1-494408.gold_dataset.department_performance`(
Dept_Id STRING,
DepartmentName STRING,
TotalEncounters INT64,
TotalTransactions INT64,
TotalBilledAmount FLOAT64,
TotalPaidAmount FLOAT64,
AvgPaymentPerTransaction FLOAT64
);

TRUNCATE TABLE `hospital-project1-494408.gold_dataset.department_performance`;

INSERT INTO `hospital-project1-494408.gold_dataset.department_performance`
SELECT
d.Dept_Id,
d.Name,
COUNT(DISTINCT e.Encounter_Key),
COUNT(DISTINCT t.Transaction_Key),
SUM(t.Amount),
SUM(t.PaidAmount),
AVG(t.PaidAmount)
FROM `hospital-project1-494408.silver_dataset.departments` d
LEFT JOIN `hospital-project1-494408.silver_dataset.encounters` e
ON SPLIT(d.Dept_Id,'-')[SAFE_OFFSET(0)] = e.DepartmentID
LEFT JOIN `hospital-project1-494408.silver_dataset.transactions` t
ON SPLIT(d.Dept_Id,'-')[SAFE_OFFSET(0)] = t.DeptID
WHERE d.is_quarantined=FALSE
GROUP BY d.Dept_Id,d.Name;


select * from `hospital-project1-494408.gold_dataset.department_performance` limit 10;*/


-----------------------------------------------5) Financial Metrics KPI-------------------------------------


CREATE OR REPLACE TABLE `hospital-project1-494408.gold_dataset.financial_metrics` AS
SELECT
SUM(Amount) TotalRevenue,
SUM(PaidAmount) TotalCollections,
SUM(Amount)-SUM(PaidAmount) OutstandingBalance,
COUNT(DISTINCT Transaction_Key) TotalTransactions
FROM `hospital-project1-494408.silver_dataset.transactions`
WHERE is_current=TRUE;


select * from `hospital-project1-494408.gold_dataset.financial_metrics` limit 10;

----------------------------------------6) Payor Performance Summary-----------------------------------------


CREATE OR REPLACE TABLE `hospital-project1-494408.gold_dataset.payor_performance` AS
SELECT
PayorID,
COUNT(DISTINCT Claim_Key) TotalClaims,
SUM(CAST(ClaimAmount AS FLOAT64)) TotalClaimAmount,
SUM(CAST(PaidAmount AS FLOAT64)) TotalPaidAmount,
COUNT(CASE WHEN ClaimStatus='Approved' THEN 1 END) ApprovedClaims
FROM `hospital-project1-494408.silver_dataset.claims`
GROUP BY PayorID;


select * from  `hospital-project1-494408.gold_dataset.payor_performance`  limit 10;