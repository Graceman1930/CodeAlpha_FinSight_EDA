-- ============================================================================
-- FINSIGHT FINANCIAL ANALYTICS - EXPLORATORY DATA ANALYSIS (SQL QUERIES)
-- ============================================================================

-- 1. Data Quality Check: Identify Missing Foreign Keys & Text Casing Issues
SELECT 
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN DepartmentID IS NULL OR DepartmentID = '' THEN 1 ELSE 0 END) AS missing_dept_ids,
    SUM(CASE WHEN CostCentreID IS NULL OR CostCentreID = '' THEN 1 ELSE 0 END) AS missing_cc_ids,
    SUM(CASE WHEN Description = UPPER(Description) OR Description = LOWER(Description) THEN 1 ELSE 0 END) AS inconsistent_casing_rows
FROM FactFinancialTransactions;

-- 2. Executive YoY Profit & Loss Summary (2024 vs 2025)
SELECT 
    EXTRACT(YEAR FROM f.TransactionDate) AS FinancialYear,
    a.PLSection,
    a.AccountGroup,
    SUM(f.AmountNGN) AS GrossAmountNGN,
    SUM(f.AmountNGN * a.NaturalSignMultiplier) AS NetImpactNGN
FROM FactFinancialTransactions f
JOIN DimAccount a ON f.AccountID = a.AccountID
GROUP BY EXTRACT(YEAR FROM f.TransactionDate), a.PLSection, a.PLSectionSort, a.AccountGroup
ORDER BY FinancialYear, a.PLSectionSort;

-- 3. Top Expense Drivers Causing Margin Compression (YoY Comparison)
WITH YearlyAccounts AS (
    SELECT 
        a.AccountName,
        a.PLSection,
        SUM(CASE WHEN EXTRACT(YEAR FROM f.TransactionDate) = 2024 THEN f.AmountNGN ELSE 0 END) AS Amount_2024,
        SUM(CASE WHEN EXTRACT(YEAR FROM f.TransactionDate) = 2025 THEN f.AmountNGN ELSE 0 END) AS Amount_2025
    FROM FactFinancialTransactions f
    JOIN DimAccount a ON f.AccountID = a.AccountID
    WHERE a.PLSection IN ('Cost of Sales', 'Operating Expenses', 'Other Expenses')
    GROUP BY a.AccountName, a.PLSection
)
SELECT 
    AccountName,
    PLSection,
    Amount_2024,
    Amount_2025,
    (Amount_2025 - Amount_2024) AS YoY_Increase_NGN,
    ROUND(((Amount_2025 - Amount_2024) / NULLIF(Amount_2024, 0)) * 100, 2) AS YoY_Growth_Pct
FROM YearlyAccounts
ORDER BY YoY_Increase_NGN DESC;

-- 4. Branch-Level Net Profit & Efficiency Analysis
SELECT 
    b.BranchName,
    b.Region,
    EXTRACT(YEAR FROM f.TransactionDate) AS FinancialYear,
    SUM(CASE WHEN a.NaturalSignMultiplier = 1 THEN f.AmountNGN ELSE 0 END) AS TotalRevenueNGN,
    SUM(CASE WHEN a.NaturalSignMultiplier = -1 THEN f.AmountNGN ELSE 0 END) AS TotalExpensesNGN,
    SUM(f.AmountNGN * a.NaturalSignMultiplier) AS NetProfitNGN
FROM FactFinancialTransactions f
JOIN DimBranch b ON f.BranchID = b.BranchID
JOIN DimAccount a ON f.AccountID = a.AccountID
GROUP BY b.BranchName, b.Region, EXTRACT(YEAR FROM f.TransactionDate)
ORDER BY b.BranchName, FinancialYear;
