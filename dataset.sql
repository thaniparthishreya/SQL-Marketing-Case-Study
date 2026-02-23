DROP TABLE IF EXISTS interactions;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS campaigns;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    email TEXT,
    signup_date DATE,
    country TEXT,
    churned INTEGER DEFAULT 0
);

CREATE TABLE campaigns (
    campaign_id INTEGER PRIMARY KEY,
    campaign_name TEXT,
    start_date DATE,
    end_date DATE,
    budget REAL,
    channel TEXT,
    attribution_type TEXT
);

CREATE TABLE interactions (
    interaction_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER,
    campaign_id INTEGER,
    interaction_type TEXT,
    interaction_date DATE,
    revenue REAL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);

INSERT INTO campaigns VALUES
(1, 'Spring Sale', '2026-03-01', '2026-03-15', 8000, 'Email', 'Organic'),
(2, 'Summer Blast', '2026-06-01', '2026-06-15', 12000, 'Social Media', 'Paid'),
(3, 'Winter Clearance', '2026-01-10', '2026-01-25', 6000, 'Email', 'Organic'),
(4, 'Black Friday', '2026-11-20', '2026-11-30', 20000, 'Paid Search', 'Paid'),
(5, 'Cyber Monday', '2026-11-28', '2026-12-02', 15000, 'Paid Search', 'Paid'),
(6, 'Referral Boost', '2026-04-01', '2026-04-20', 5000, 'Referral', 'Organic'),
(7, 'Influencer Push', '2026-05-01', '2026-05-10', 9000, 'Social Media', 'Paid'),
(8, 'Holiday Deals', '2026-12-01', '2026-12-20', 18000, 'Email', 'Organic'),
(9, 'Back to School', '2026-08-01', '2026-08-20', 7000, 'Social Media', 'Paid'),
(10, 'New Year Promo', '2026-12-28', '2027-01-05', 10000, 'Email', 'Organic');

WITH RECURSIVE generate_customers(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM generate_customers WHERE n < 1000
)

INSERT INTO customers (name, email, signup_date, country, churned)
SELECT 
    'Customer_' || n,
    'customer' || n || '@email.com',
    date('2025-01-01', '+' || (abs(random()) % 365) || ' days'),
    CASE 
        WHEN n % 5 = 0 THEN 'USA'
        WHEN n % 5 = 1 THEN 'Canada'
        WHEN n % 5 = 2 THEN 'UK'
        WHEN n % 5 = 3 THEN 'Australia'
        ELSE 'India'
    END,
    CASE 
        WHEN n % 5 = 0 THEN 1
        ELSE 0
    END
FROM generate_customers;

WITH RECURSIVE generate_interactions(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM generate_interactions WHERE n < 8000
)

INSERT INTO interactions (
    customer_id,
    campaign_id,
    interaction_type,
    interaction_date,
    revenue
)

SELECT 
    abs(random()) % 1000 + 1,
    abs(random()) % 10 + 1,
    CASE 
        WHEN n % 8 = 0 THEN 'purchased'
        WHEN n % 3 = 0 THEN 'clicked_link'
        ELSE 'opened_email'
    END,
    date('2026-01-01', '+' || (abs(random()) % 365) || ' days'),
    CASE 
        WHEN n % 8 = 0 THEN
            CASE 
                WHEN strftime('%m', date('2026-01-01', '+' || (abs(random()) % 365) || ' days')) IN ('11','12')
                    THEN (abs(random()) % 800) + 200
                ELSE (abs(random()) % 400) + 50
            END
        ELSE 0
    END
FROM generate_interactions;

INSERT INTO interactions (
    customer_id,
    campaign_id,
    interaction_type,
    interaction_date,
    revenue
)

SELECT 
    customer_id,
    abs(random()) % 10 + 1,
    'purchased',
    date('2026-09-01', '+' || (abs(random()) % 90) || ' days'),
    (abs(random()) % 500) + 100
FROM customers
WHERE customer_id % 7 = 0;

CREATE INDEX idx_customer ON interactions(customer_id);
CREATE INDEX idx_campaign ON interactions(campaign_id);
CREATE INDEX idx_date ON interactions(interaction_date);