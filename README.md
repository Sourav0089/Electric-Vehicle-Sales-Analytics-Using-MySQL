📌 Project Summary:-

Designed and implemented a Data Warehouse in MySQL to analyze India’s Electric Vehicle (EV) sales dataset (2014–2024).

🔹 Objectives
✅ Built a Star Schema (Fact + Dimensions)
✅ Performed ETL using SQL scripts
✅ Wrote advanced analytical queries (window functions, CTEs, stored procedures, views).
✅ Delivered insights such as yearly growth trends, state-wise adoption, vehicle category analysis.

🏗️ Database Schema (Star Schema)

staging_ev_sales → Raw dataset

dim_date → Date-related attributes

dim_state → State dimension

dim_vehicle → Vehicle class, category, type

fact_ev_sales → Central fact table storing sales quantities

Used Primary Keys, Foreign Keys, Unique Constraints.

ERD (Entity Relationship Diagram):


   dim_date        dim_state        dim_vehicle
      |               |                 |
      |               |                 |
      +--------- fact_ev_sales ---------+



🔹 Key SQL Features Demonstrated

Database Design

Normalization (star schema).

Constraints (PK, FK, Unique).

ETL Process

INSERT … SELECT for populating dimensions & fact.

Analytical Queries

Window functions (LAG, ROW_NUMBER).

Ranking (Top N states per year).

Growth % calculations.

Advanced SQL

CTEs (modular queries).

Views (dashboard-ready).

Stored Procedures (parameterized analysis).

🔹 Tools Used

MySQL (database design & queries)
Power BI (optional) (visualization)
Excel / Python (CSV cleaning before loading)

🔹 How to Run

Import dataset into staging_ev_sales.

Run table creation scripts (dim_*, fact_ev_sales).

Populate dimensions & fact using ETL scripts.

Run analysis queries (analysis_queries.sql).

(Optional) Connect MySQL → Power BI.

📊 Key Analysis Queries

Total EV sales by year

Top 5 states by EV adoption

EV category market share (2W, 3W, 4W, Buses, Others)

Year-over-Year growth with window functions

Cumulative EV adoption trend

Peak sales months by year

Top states per year (ranking with ROW_NUMBER)

Market share by vehicle type annually

💡 Business Insights

Strong YoY Growth → EV adoption has grown rapidly, with double-digit YoY growth in most recent years.

Top 5 States Dominate → A handful of states (Uttar Pradesh, Maharashtra, Karnataka, Delhi, Rajasthan) contribute a large % of national EV sales.

Two-Wheelers Lead Adoption → EV adoption is driven mainly by 2-wheelers (affordable & convenient for urban mobility).

Seasonality Exists → Certain months (festive seasons, policy incentive announcements) show peak sales.

Uneven State Adoption → Some states have very low or inconsistent sales, highlighting the need for policy push.

📌 Recommendations

For Policymakers → Focus on EV infrastructure (charging stations) in low-adoption states to balance adoption.

For Manufacturers → Continue focusing on 2W segment, but invest in 4W and buses for long-term sustainability.

For Businesses → Target top states with aggressive EV financing & incentives.

For Investors → EV adoption is on a strong growth trajectory; 2W and 3W categories present high ROI opportunities.

