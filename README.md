# FinSight Nigeria: Exploratory Data Analysis (2024–2025)

## Project Overview
This project was completed as **Task 2 (Exploratory Data Analysis)** for the **CodeAlpha Data Analytics Internship**. The objective is to investigate why FinSight Nigeria's profit margins compressed and net profit turned negative in 2025 despite strong top-line revenue growth.

## Tools & Technologies Used
* **Python (Pandas, NumPy, Matplotlib, Seaborn):** Data cleaning, Star Schema joins, YoY financial analysis, and data visualization.
* **SQL:** Star Schema multi-table joins, data quality auditing, and expense driver queries.

## Key Analytical Findings
1. **Margin Compression:** Although revenue grew across Distribution (+56%), Institutional Sales (+49%), and E-Commerce (+22%), total costs outpaced revenue growth in 2025, resulting in a net deficit of **-₦1.38 Billion**.
2. **Primary Cost Drivers:** **Cost of Goods Sold – Finished Goods**, **Diesel & Fuel Expense (Generators)** (+183% YoY surge), and **Importation & Customs Clearance** were the largest contributors to expense escalation.

## Repository Contents
* `FinSight_Financial_Analytics.xlsx` — Raw Star Schema dataset (Fact & Dimension tables).
* `cleaned_finsight_transactions.csv` — Cleaned and joined master dataset.
* `finsight_eda.ipynb` — Complete Python EDA Jupyter Notebook with outputs and charts.
* `finsight_queries.sql` — SQL queries for data quality checks and P&L analysis.
* `chart1_yoy_financial_performance.png` — YoY Revenue, Costs, and Net Profit comparison.
* `chart2_top_cost_drivers.png` — Top 8 expense accounts driving margin compression.
* `chart3_branch_profitability.png` — Branch-level profitability breakdown (2024 vs 2025).
