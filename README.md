A Data Warehouse project in MySQL designed to analyze India’s Electric Vehicle (EV) sales from 2014–2024.
It demonstrates data modeling, ETL, analytical SQL, and insights generation on real-world datasets.

🎯 Objectives
✅ Designed Star Schema (Fact + Dimensions)

✅ Performed ETL using SQL scripts

✅ Wrote advanced analytical queries (CTEs, Window Functions, Stored Procedures, Views)

✅ Generated business insights: growth trends, state-wise adoption, category analysis

🏗️ Database Schema
Star Schema Design

lua
Copy code
   dim_date        dim_state        dim_vehicle
      |               |                 |
      |               |                 |
      +--------- fact_ev_sales ---------+
Tables

staging_ev_sales → Raw dataset

dim_date → Date-related attributes

dim_state → State dimension

dim_vehicle → Vehicle class, category, type

fact_ev_sales → Central fact table storing sales quantities

✔️ Implemented Primary Keys, Foreign Keys, and Unique Constraints

🔑 Key SQL Features
🗂️ Database Design
Star Schema (Fact + Dimensions)

Normalization + Constraints

🔄 ETL Process
INSERT … SELECT for staging → dimensions → fact

📊 Analytical Queries
Window Functions: ROW_NUMBER, RANK, LAG

Growth % calculations

Top-N ranking queries (Top states per year)

Cumulative adoption analysis

⚙️ Advanced SQL
CTEs → Modular queries

Views → Dashboard-ready

Stored Procedures → Parameterized analysis

🛠️ Tools Used
MySQL → Data warehouse design & queries

Power BI (optional) → Visualization dashboards

Excel / Python → CSV cleaning & preprocessing

🚀 How to Run
Import dataset → staging_ev_sales

Run table creation scripts (dim_*, fact_ev_sales)

Populate dimensions & fact with ETL scripts

Execute analysis queries (analysis_queries.sql)

(Optional) Connect MySQL → Power BI for dashboards

📊 Example Analysis Queries
✅ Total EV sales by year

✅ Top 5 states by EV adoption

✅ EV category market share (2W, 3W, 4W, Buses, Others)

✅ Year-over-Year growth %

✅ Cumulative EV adoption trend

✅ Peak sales months by year

✅ Market share by vehicle type annually

💡 Business Insights
📈 Strong YoY Growth → Double-digit growth in recent years

🏆 Top 5 States Dominate → Uttar Pradesh, Maharashtra, Karnataka, Delhi, Rajasthan

🛵 2W Lead Adoption → Affordable & convenient, driving EV penetration

📅 Seasonality Exists → Festive seasons & policy pushes create sales spikes

⚖️ Uneven Adoption → Some states lag, needing targeted infrastructure

📌 Recommendations
For Policymakers → Expand charging infra in low-adoption states

For Manufacturers → Focus on 2W, but invest in 4W & buses

For Businesses → Prioritize top states with EV financing & incentives

For Investors → 2W & 3W categories show high ROI opportunities

✨ This project showcases end-to-end Data Warehousing + Analytics using SQL.
Perfect for data engineering, analytics, and business intelligence portfolios.
