# 🛒 Olist Brazilian E-Commerce — SQL Retail Case Study

A complete SQL case study analyzing 100,000+ real e-commerce orders from Olist, Brazil's largest online marketplace. This project demonstrates end-to-end SQL skills across 15 business questions — from basic aggregations to advanced window functions.

---

## 📌 Problem Statement

Olist connects small Brazilian merchants to major marketplaces. With data spanning customers, orders, payments, reviews, sellers and products, this project answers critical business questions:

- What is the overall revenue and order volume?
- Which product categories and sellers drive the most revenue?
- How efficient is the delivery process?
- What do customer satisfaction scores reveal?
- Where are the biggest opportunities for growth and retention?

---

## 📊 Key Business Findings

| Metric | Value |
|---|---|
| Total Orders | 99,441 |
| Total Revenue | $16,008,872 |
| Average Order Value | $154.10 |
| Average Delivery Time | 12 days |
| Top Payment Method | Credit Card (76,795 transactions) |
| Top Revenue Category | Health & Beauty ($1.26M) |
| 5-Star Review Rate | 59.9% |
| One-time Buyers | 93,099 (96.9%) |
| Repeat Buyers | 2,997 (3.1%) |

---

## 🗂️ Database Schema

9 tables, 600,000+ total rows across all tables.

```
OlistRetail Database
│
├── customers          (99,441 rows)   — customer location data
├── orders             (99,441 rows)   — order status and timestamps
├── order_items        (112,650 rows)  — products per order, price, freight
├── order_payments     (103,886 rows)  — payment type and value
├── order_reviews      (90,506 rows)   — review scores and comments
├── products           (32,951 rows)   — product dimensions and category
├── sellers            (3,093 rows)    — seller location data
├── geolocation        (2,000,322 rows)— zip code coordinates
└── product_category_translation (71) — Portuguese to English categories
```

---

## 📁 Project Structure

```
SQL-Retail-Case-Study/
│
├── olist_analysis.sql          # All 15 queries
├── setup/
│   └── create_tables.sql       # Database and table creation script
│
├── results/                    # Screenshots of all query outputs
│   ├── q1_order_status.png
│   ├── q2_top_cities.png
│   ├── q3_total_revenue.png
│   ├── q4_payment_methods.png
│   ├── q5_avg_order_value.png
│   ├── q6_monthly_trend.png
│   ├── q7_top_categories.png
│   ├── q8_delivery_time.png
│   ├── q9_top_sellers.png
│   ├── q10_customer_retention.png
│   ├── q11_review_scores.png
│   ├── q12_late_deliveries.png
│   ├── q13_revenue_by_state.png
│   ├── q14_category_ratings.png
│   └── q15_running_total.png
│
└── README.md
```

---

## 🔍 Query Breakdown — 15 Business Questions

### 🟢 Basic (Q1–Q5) — Aggregations & Grouping

**Q1 — Order Status Distribution**
How many orders are in each status? Delivered orders dominate at 96,478.
```sql
SELECT order_status, COUNT(*) as total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;
```

**Q2 — Top 10 Cities by Customers**
São Paulo and Belo Horizonte lead with 2,773 customers each.
```sql
SELECT TOP 10 customer_city, COUNT(*) as total_customers
FROM customers
GROUP BY customer_city
ORDER BY total_customers DESC;
```

**Q3 — Total Revenue**
Platform generated $16,008,872 in total payment value.
```sql
SELECT ROUND(SUM(payment_value), 2) as total_revenue
FROM order_payments;
```

**Q4 — Payment Method Breakdown**
Credit card accounts for 74% of all transactions.
```sql
SELECT payment_type, COUNT(*) as usage_count,
ROUND(SUM(payment_value), 2) as total_value
FROM order_payments
GROUP BY payment_type
ORDER BY usage_count DESC;
```

**Q5 — Average Order Value**
Average transaction value is $154.10.
```sql
SELECT ROUND(AVG(payment_value), 2) as avg_order_value
FROM order_payments;
```

---

### 🟡 Intermediate (Q6–Q10) — JOINs, Subqueries & Date Functions

**Q6 — Monthly Order Trend**
Orders grew from 4 in Sept 2016 to 7,000+ by late 2017 — rapid platform growth.
```sql
SELECT FORMAT(CAST(order_purchase_timestamp AS DATETIME), 'yyyy-MM') as order_month,
COUNT(*) as total_orders
FROM orders
GROUP BY FORMAT(CAST(order_purchase_timestamp AS DATETIME), 'yyyy-MM')
ORDER BY order_month;
```

**Q7 — Top 10 Categories by Revenue**
Health & Beauty leads at $1.26M, followed by Watches & Gifts at $1.2M.
Requires JOIN across order_items → products → product_category_translation.

**Q8 — Average Delivery Time**
Average of 12 days from purchase to delivery across all completed orders.
Uses DATEDIFF across purchase and delivery timestamp columns.

**Q9 — Top 10 Sellers by Revenue**
Top seller generated $229,472 in revenue across 113 orders — based in Guariba, SP.
Requires JOIN across order_items → sellers.

**Q10 — Customer Retention Analysis**
96.9% of customers are one-time buyers — a major retention opportunity for the business.
Uses subquery to count orders per unique customer, then CASE WHEN to classify.

---

### 🔴 Advanced (Q11–Q15) — Window Functions, Multi-table JOINs, HAVING

**Q11 — Review Score Distribution with Percentages**
59.9% of reviews are 5-star. Only 9.7% are 1-star. Uses `COUNT() OVER()` window function for percentage calculation.

**Q12 — Late Deliveries by State**
MG (Minas Gerais) has the most late deliveries at 638. Uses CAST comparison of actual vs estimated delivery dates.

**Q13 — Revenue by State**
SP (São Paulo) dominates revenue — consistent with being Brazil's economic hub.
3-table JOIN: orders → customers → order_payments.

**Q14 — Average Review Score by Category**
Books & General Interest scores highest at 4.56. Uses 5-table JOIN with HAVING to filter categories with 100+ reviews.

**Q15 — Running Total Revenue by Month (Window Function)**
Tracks cumulative revenue growth from $252 in Sept 2016 to $16M by Oct 2018.
Uses `SUM() OVER(ORDER BY ... ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)`.

---

## 🛠️ Tools Used

| Tool | Usage |
|---|---|
| **SQL Server (SSMS)** | Database creation, data import, query execution |
| **BULK INSERT** | Loading 600,000+ rows from CSV files |
| **T-SQL** | All queries — aggregations, joins, subqueries, window functions |
| **Kaggle** | Source dataset |

---

## 🚀 How to Reproduce

### Step 1 — Get the Dataset
Download the **Brazilian E-Commerce Public Dataset by Olist** from [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

### Step 2 — Set Up the Database
Open SSMS → New Query → run `setup/create_tables.sql` to create the OlistRetail database and all 9 tables.

### Step 3 — Load the Data
Use BULK INSERT with the following settings for each CSV:
```sql
BULK INSERT table_name
FROM 'your\path\to\file.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
```

### Step 4 — Run the Analysis
Open `olist_analysis.sql` and run all 15 queries.

---

## 💡 Business Recommendations

1. **Fix the retention problem** — 96.9% one-time buyers signals poor post-purchase engagement. Email re-marketing and loyalty programs could significantly increase repeat purchases.
2. **Reduce delivery time in MG state** — highest late delivery count at 638. Partnering with local logistics providers in Minas Gerais would improve customer satisfaction.
3. **Invest in Health & Beauty inventory** — top revenue category at $1.26M. Expanding seller base in this category has the highest revenue upside.
4. **Push credit card installments** — already the dominant payment method. Offering more installment options could increase average order value beyond $154.
5. **Address 1-star reviews (9.7%)** — even a small reduction in negative reviews would meaningfully improve platform trust and conversion rates.

---

## 📝 Dataset

- **Source:** [Brazilian E-Commerce Public Dataset — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- **Records:** 100,000+ orders from 2016–2018
- Raw CSVs are **not included** in this repo. Download directly from Kaggle.

---

*Built to demonstrate end-to-end SQL skills — from database setup and data loading to complex multi-table analysis and window functions 📊*
