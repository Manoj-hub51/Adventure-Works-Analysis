# Adventure Works Sales Analysis

---

## Project Overview
This project focuses on analyzing sales and customer data from the Adventure Works dataset to generate actionable business insights. The goal is to support data-driven decision-making through structured analysis and interactive dashboards.

---

## Business Problem
The business needs visibility into:
- Sales performance across regions and products  
- Customer purchasing behavior  
- Revenue trends over time  
- Key drivers impacting profitability  

---

## Dataset Description
The dataset includes:
- Sales transactions  
- Customer information  
- Product details  
- Regional sales data  

Data was cleaned and transformed before analysis to ensure accuracy and consistency.

---

## Tools Used
- **Excel** – Data cleaning and preprocessing  
- **SQL** – Data extraction, joins, aggregations  
- **Power BI** – Interactive dashboards and KPI tracking  
- **Tableau** – Data visualization and reporting  

---

## Key Insights
- Identified top-performing products contributing to overall revenue  
- Analyzed monthly sales trends to track growth patterns  
- Discovered high-value customer segments  
- Evaluated regional performance differences  

---

## Dashboard Screenshots

### 🔹 Power BI Dashboard
![Power BI Dashboard](https://raw.githubusercontent.com/Manoj-hub51/Adventure-Works-Analysis/main/visuals/Pwbix_Dashboard_screenshot.png)

### 🔹 Tableau Dashboard
![Tableau Dashboard](https://raw.githubusercontent.com/Manoj-hub51/Adventure-Works-Analysis/main/visuals/Tableau_Dshaboard_Screenshot1.png)

---

## SQL Highlights
Example queries used in analysis:

```sql
-- Total Sales by Product
SELECT ProductName, SUM(SalesAmount) AS TotalSales
FROM Sales
GROUP BY ProductName
ORDER BY TotalSales DESC;

-- Monthly Sales Trend
SELECT YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month, 
SUM(SalesAmount) AS Revenue
FROM Sales
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;
```

---

## How to Use
1. Download the dataset and files from this repository  
2. Run SQL queries to explore the data  
3. Open Power BI (.pbix) file to view dashboards  
4. Use Tableau workbook for additional visual insights  

---

## Outcome
Developed a complete end-to-end data analytics solution that transforms raw data into meaningful business insights using industry-standard tools.
