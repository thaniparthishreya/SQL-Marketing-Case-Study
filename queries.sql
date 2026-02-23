SELECT 
    c.campaign_name,
    SUM(i.revenue) AS total_revenue,
    c.budget,
    ROUND(((SUM(i.revenue) - c.budget) / c.budget) * 100, 2) AS ROI_percent
FROM campaigns c
LEFT JOIN interactions i 
    ON c.campaign_id = i.campaign_id 
    AND i.interaction_type = 'purchased'
GROUP BY c.campaign_id;

SELECT 
    c.campaign_name,
    ROUND(c.budget / COUNT(DISTINCT i.customer_id), 2) AS CAC
FROM campaigns c
JOIN interactions i 
    ON c.campaign_id = i.campaign_id
WHERE i.interaction_type = 'purchased'
GROUP BY c.campaign_id;

SELECT 
    customer_id,
    ROUND(SUM(revenue), 2) AS lifetime_value
FROM interactions
WHERE interaction_type = 'purchased'
GROUP BY customer_id
ORDER BY lifetime_value DESC
LIMIT 10;

SELECT 
    c.attribution_type,
    ROUND(SUM(i.revenue), 2) AS total_revenue
FROM campaigns c
JOIN interactions i 
    ON c.campaign_id = i.campaign_id
WHERE i.interaction_type = 'purchased'
GROUP BY c.attribution_type;

SELECT 
    cu.churned,
    ROUND(SUM(i.revenue), 2) AS total_revenue
FROM customers cu
JOIN interactions i 
    ON cu.customer_id = i.customer_id
WHERE i.interaction_type = 'purchased'
GROUP BY cu.churned;

SELECT 
    strftime('%Y-%m', interaction_date) AS month,
    ROUND(SUM(revenue), 2) AS monthly_revenue
FROM interactions
WHERE interaction_type = 'purchased'
GROUP BY month
ORDER BY month;