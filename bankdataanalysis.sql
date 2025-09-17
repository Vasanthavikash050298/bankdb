CREATE USER vasanth WITH PASSWORD 'Vasanth@05';
GRANT ALL PRIVILEGES ON DATABASE bankdb TO vasanth;
-- Grant permission to create tables

-- Grant permission to create tables
GRANT CREATE ON DATABASE bankdb TO vasanth;



-- Grant permission to insert/update/delete data
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO vasanth;

-- Optional: future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO vasanth;

-- Grant usage on schema
GRANT USAGE ON SCHEMA public TO vasanth;

-- Grant permission to create tables
GRANT CREATE ON SCHEMA public TO vasanth;
select* from customers
select*from transactions
select*from accounts


--1.Total number of transactions per customer
select c.customer_id,
    c.name AS customer_name,
    COUNT(t.txn_id) AS total_transactions from customers c
left join accounts a on c.customer_id=a.customer_id
left join transactions t on a.account_id=t.account_id
group by 1,2
order by total_transactions desc

--2. Top 5 customers by total transaction value
select 
    c.name AS customer_name,
	sum(t.amount) as total_value
     from customers c
left join accounts a on c.customer_id=a.customer_id
left join transactions t on a.account_id=t.account_id
where t.amount is not null
group by customer_name
order by total_value desc
limit 5

--3. Average transaction amount per account type
SELECT 
    txn_type,
    channel,
    ROUND(AVG(amount)::numeric, 2) AS average_amount
FROM transactions
GROUP BY txn_type, channel
ORDER BY average_amount DESC;

--4. Monthly revenue (credits only)
SELECT 
    DATE_TRUNC('month', t.txn_date) AS month,
    ROUND(SUM(t.amount)::numeric,2) AS total_revenue
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
WHERE t.txn_type = 'Credit'
GROUP BY month
ORDER BY month;


--5. Top 3 transaction channels by volume
SELECT 
    t.channel,
    COUNT(*) AS txn_count
FROM transactions t
GROUP BY t.channel
ORDER BY txn_count DESC
LIMIT 3;

--6. Dormant customers (no transactions in last 6 months)
SELECT 
    c.customer_id,
    c.name AS customer_name
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
LEFT JOIN transactions t 
    ON a.account_id = t.account_id 
    AND t.txn_date >= CURRENT_DATE - INTERVAL '6 months'
WHERE t.txn_id IS NULL;


--7. Customers with highest debit usage
SELECT 
    c.customer_id,
    c.name AS customer_name,
    SUM(t.amount) AS total_debit
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
WHERE t.txn_type = 'Debit'
GROUP BY c.customer_id, customer_name
ORDER BY total_debit DESC
LIMIT 5;
--end project

