# DataAnalytics-Assessment
This repository contains my SQL solutions for a data analytics assessment. Each question has been implemented in a separate `.sql` file as outlined below. The solutions follow best practices in SQL query structuring and are fully commented for clarity and review.

---

# DataAnalytics-Assessment

This repository contains my SQL solutions for a data analytics assessment. Each question has been implemented in a separate `.sql` file as outlined below. The solutions follow best practices in SQL query structuring and are fully commented for clarity and review.

---

## 📁 Repository Structure

```

DataAnalytics-Assessment/
│
├── Assessment\_Q1.sql        # High-Value Customers with Multiple Products
├── Assessment\_Q2.sql        # Transaction Frequency Analysis
├── Assessment\_Q3.sql        # Account Inactivity Alert
├── Assessment\_Q4.sql        # Customer Lifetime Value (CLV) Estimation
│
└── README.md

```

---

## ✅ Submission Requirements

- All `.sql` files contain a single, well-formatted SQL query.
- Complex logic is clearly explained using inline comments.
- This `README.md` file provides detailed explanations for each query and documents any challenges encountered.

---

## 🧠 Per-Question Explanations

### **Assessment_Q1.sql — High-Value Customers with Multiple Products**

**Objective:**  
Identify customers who have at least one funded savings plan **and** one funded investment plan. Rank them by total deposits.

**Approach:**
- Filter for funded savings and funded investment plans using JOINs.
- Group by customer and count savings/investment accounts.
- Sum the deposits to calculate total deposits.
- Sort by total deposits descending.

**Key Insight:**
This identifies cross-sell opportunities—ideal for targeting high-value customers with multiple financial products.

**Challenge:**
Ensuring we didn’t double-count customers with multiple accounts required aggregation at the right level (`owner_id`).

---

### **Assessment_Q2.sql — Transaction Frequency Analysis**

**Objective:**  
Classify customers based on their average monthly transaction frequency into:
- High Frequency (≥10/month)
- Medium Frequency (3–9/month)
- Low Frequency (≤2/month)

**Approach:**
- Count transactions per customer.
- Compute account tenure in months using `MIN(created_at)` and `MAX(created_at)`.
- Compute average monthly transactions.
- Use CASE statements to bucket customers by frequency category.
- Group and aggregate to get category summaries.

**Key Insight:**
Enables segmentation for personalized marketing, product recommendations, or churn prediction.

**Challenge:**
Correctly handling edge cases where transaction spans were less than a full month to avoid division by zero.

---

### **Assessment_Q3.sql — Account Inactivity Alert**

**Objective:**  
Flag active savings or investment accounts that have **not had any inflow transactions in the last 365 days**.

**Approach:**
- Identify last inflow transaction (amount > 0) per account.
- Combine savings and investment accounts using `UNION ALL`.
- Filter where last inflow date is more than 365 days ago or NULL (never transacted).
- Calculate `inactivity_days` using `NOW() - last_transaction_date`.

**Key Insight:**
This is critical for proactive outreach and retention strategies for dormant accounts.

**Challenge:**
Ensuring we accounted for accounts that have **never** had any transactions (i.e., `last_transaction_date IS NULL`).

---

### **Assessment_Q4.sql — Customer Lifetime Value (CLV) Estimation**

**Objective:**  
Estimate each customer's CLV using the formula:  
\[
CLV = \left( \frac{\text{Total Transactions}}{\text{Tenure in Months}} \right) \times 12 \times \text{Avg Profit per Transaction}
\]  
Assume profit per transaction is **0.1% of transaction value**.

**Approach:**
- Compute total number and value of transactions per customer.
- Compute tenure in months from `date_joined` to `NOW()`.
- Calculate average profit per transaction (`0.001 × total_value / count`).
- Use the formula above to compute CLV.
- Sort descending by CLV.

**Key Insight:**
Helps prioritize marketing or retention efforts toward the most valuable customers.

**Challenge:**
Handling tenure values of zero or NULL and avoiding division by zero via `NULLIF`.

---

## ⚠️ Important Notes

- All SQL code is **original and authored by me**.
- I did not use or copy any third-party code or solutions.
- No database dumps or non-SQL files are included, in compliance with the submission guidelines.

---

## 📌 Summary

This assessment demonstrated practical SQL proficiency across customer segmentation, behavioral analytics, inactivity monitoring, and financial value estimation. Each problem was approached with clean, efficient SQL and careful handling of edge cases.

---

Thank you for reviewing my work!
