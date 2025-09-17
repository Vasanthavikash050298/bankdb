# bankdb
bank etl project


📄 README.md – Banking ETL & Analytics Project
# 💳 Banking Data Pipeline: ETL + SQL Analytics

## 📌 Project Overview
This project demonstrates an **end-to-end data pipeline** for a **Banking Analytics System**.  
- Performed **ETL (Extract, Transform, Load)** using **Python (Pandas)**.  
- Loaded cleaned datasets into **PostgreSQL**.  
- Wrote **SQL queries** to answer real-world business problems and derive actionable insights.  

This project highlights both **data engineering (ETL)** and **data analytics (SQL insights)** skills.

---

## ⚙️ ETL Process (with Pandas)
1. **Extract**  
   - Source files: `customers.csv`, `accounts.csv`, `transactions.csv`.  

2. **Transform**  
   - Standardized column names → lowercase, no spaces.  
   - Cleaned missing values & formatted `date` columns.  
   - Derived new features → e.g., `age` column from `dob`.  

   ```python
   df_customers.columns = [col.strip().lower() for col in df_customers.columns]
   df_customers['age'] = pd.to_datetime('today').year - pd.to_datetime(df_customers['dob']).dt.year


Load

Loaded transformed DataFrames into PostgreSQL using SQLAlchemy.

Created 3 core tables: customers, accounts, transactions.

df_customers.to_sql("customers", engine, if_exists="replace", index=False)
df_accounts.to_sql("accounts", engine, if_exists="replace", index=False)
df_txn.to_sql("transactions", engine, if_exists="replace", index=False)

🗂️ Database Schema
1. customers

customer_id (PK)

first_name, last_name

dob, age, city, created_date

2. accounts

account_id (PK)

customer_id (FK)

account_type, opened_date, balance

3. transactions

txn_id (PK)

account_id (FK)

txn_date, txn_type (credit/debit), amount, channel

🎯 Business Problems & SQL Queries
**1️⃣ Total Transactions per Customer**

***Sql

SELECT c.customer_id, COUNT(t.txn_id) AS total_txns
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
GROUP BY c.customer_id;
***


🔍 Insight: Found top active customers for loyalty targeting.

**2️⃣ Top 5 Customers by Transaction Value**
***sql

SELECT c.customer_id, SUM(t.amount) AS total_value
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
GROUP BY c.customer_id
ORDER BY total_value DESC
LIMIT 5;

***




🔍 Insight: Identified High Net-Worth Individuals (HNI clients).

**3️⃣ Monthly Revenue Trend (Credits Only)**
***sql
SELECT DATE_TRUNC('month', t.txn_date) AS month, SUM(t.amount) AS revenue
FROM transactions t
WHERE t.txn_type = 'credit'
GROUP BY month
ORDER BY month;
***


🔍 Insight: Revenue spikes in March & December (bonus/salary cycles).

**4️⃣ Dormant Customers (No Transactions in 6 Months)**
***sql
SELECT c.customer_id, c.first_name, c.last_name
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
LEFT JOIN transactions t 
       ON a.account_id = t.account_id 
       AND t.txn_date >= CURRENT_DATE - INTERVAL '6 months'
WHERE t.txn_id IS NULL;
***


🔍 Insight: ~12% customers inactive → potential churn.

**5️⃣ Top Transaction Channels**
***sql
SELECT channel, COUNT(*) AS txn_count, SUM(amount) AS total_value
FROM transactions
GROUP BY channel
ORDER BY txn_count DESC;
***


🔍 Insight: Online transactions = 60% of volume and 70% of value → strong digital adoption.

📊 Key Insights

80/20 rule: 20% customers drive majority of revenue.

Current accounts have larger transaction sizes vs savings.

Digital channels dominate over ATM/branch usage.

Churn risk: Dormant customers identified for reactivation.

Revenue seasonality observed in specific months.

🚀 Tech Stack

Python (Pandas, SQLAlchemy) → ETL

PostgreSQL → Data Warehouse

SQL → Analytics & Insights

Jupyter Notebook → ETL scripts
