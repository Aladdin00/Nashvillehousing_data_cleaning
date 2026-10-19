<div align="center">

# 🏠 Nashville Housing Data Cleaning in SQL

**Turning a messy real-estate dataset into an analysis-ready table using T-SQL.**

![SQL Server](https://img.shields.io/badge/SQL%20Server-T--SQL-CC2927)
![Focus](https://img.shields.io/badge/focus-data%20cleaning-blue)
![Status](https://img.shields.io/badge/status-complete-brightgreen)

</div>

---

## Table of Contents

- [Overview](#overview)
- [Skills Demonstrated](#skills-demonstrated)
- [Dataset](#dataset)
- [Cleaning Steps](#cleaning-steps)
- [Before and After](#before-and-after)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Key Takeaways](#key-takeaways)
- [Next Steps](#next-steps)
- [Contact](#contact)

## Overview

Raw data is rarely ready for analysis. This project takes a Nashville housing sales dataset and cleans it entirely with SQL, fixing inconsistent formats, filling missing values, splitting combined fields, standardizing categories, flagging duplicates, and removing unused columns.

The result is a tidy table that can be used directly for reporting, dashboards or further analysis.

## Skills Demonstrated

| Skill | Where it's used |
|-------|-----------------|
| **Data type conversion** | `CONVERT` to standardize the sale date format |
| **Self joins** | Matching records with the same `ParcelID` to fill missing addresses |
| **`ISNULL` and `UPDATE ... JOIN`** | Populating null property addresses |
| **String functions** | `SUBSTRING`, `CHARINDEX`, `LEN` to split property addresses |
| **`PARSENAME` and `REPLACE`** | Splitting owner addresses into address, city and state |
| **`CASE` statements** | Standardizing `Y`/`N` to `Yes`/`No` |
| **CTEs and window functions** | `ROW_NUMBER() OVER (PARTITION BY ...)` to detect duplicates |
| **`ALTER TABLE`** | Adding new columns and dropping unused ones |

## Dataset

- **Table:** `NashvilleHousing` in a SQL Server database named `project 1`
- **Content:** Nashville property sales records including parcel ID, property and owner address, sale date, sale price, legal reference, tax district and sold-as-vacant status

> Data source: Nashville Housing Data for Data Cleaning (public dataset). *(Update this line if you used a different source.)*

## Cleaning Steps

### 1. Standardize the date format
Converted `SaleDate` from a datetime to a clean `Date` and stored it in a new `SaleDateConverted` column.

### 2. Populate missing property addresses
Some records had a null `PropertyAddress`, but other rows with the same `ParcelID` had the address. A **self join** on `ParcelID` (with different `UniqueID`s) fills the gaps using `ISNULL`.

```sql
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
  ON a.ParcelID = b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;
```

### 3. Split addresses into individual columns
- **Property address** was split into `PropertySplitAddress` and `PropertySplitCity` using `SUBSTRING` and `CHARINDEX`
- **Owner address** was split into `OwnerSplitAddress`, `OwnerSplitCity` and `OwnerSplitState` using `PARSENAME` and `REPLACE`

### 4. Standardize the "Sold as Vacant" field
The column mixed `Y`, `N`, `Yes` and `No`. A `CASE` statement unifies everything to **Yes / No**.

### 5. Identify duplicate records
A CTE with `ROW_NUMBER()` partitioned by parcel ID, property address, sale price, sale date and legal reference flags duplicate rows (any row with `row_num > 1`).

### 6. Remove unused columns
Dropped `OwnerAddress`, `TaxDistrict`, `PropertyAddress` and the original `SaleDate` once their cleaned replacements existed.

## Before and After

| Issue | Before | After |
|-------|--------|-------|
| Sale date | Date with time component | `SaleDateConverted` (date only) |
| Property address | Single combined field, some nulls | `PropertySplitAddress` + `PropertySplitCity`, nulls filled |
| Owner address | Single combined field | `OwnerSplitAddress` + `OwnerSplitCity` + `OwnerSplitState` |
| Sold as vacant | `Y`, `N`, `Yes`, `No` | `Yes`, `No` |
| Duplicates | Undetected | Identified with `ROW_NUMBER()` |
| Unused columns | Present | Removed |

> 💡 Add a screenshot of the table before and after cleaning here to make this section stand out.

## Getting Started

### Prerequisites
- Microsoft SQL Server
- SQL Server Management Studio (SSMS) or Azure Data Studio

### Setup
1. Import the Nashville housing data into a table named `NashvilleHousing` (the script uses a database called `project 1`; update the name if yours differs).
2. Open `SQLQuery2 (Cleaning Data).sql` in SSMS.
3. Run the script section by section. Work on a **copy** of the table, since the final steps permanently drop columns.

## Project Structure

```
├── SQLQuery2 (Cleaning Data).sql   # All cleaning queries
├── data/                           # Raw dataset (optional)
└── README.md
```

## Key Takeaways

- Self joins can recover missing values from related records
- `PARSENAME` is a concise alternative to nested `SUBSTRING`/`CHARINDEX` for delimited text
- `ROW_NUMBER()` with `PARTITION BY` is a reliable way to detect duplicates
- Previewing each change with a `SELECT` before running the `UPDATE` reduces mistakes

## Next Steps

- Delete the flagged duplicates (the CTE currently identifies them; a `DELETE` can be applied to `row_num > 1`)
- Wrap the process in a stored procedure so it can be re-run on new data
- Connect the cleaned table to Tableau or Power BI for housing market analysis

## Contact

Ali Eldin Mohamed · [LinkedIn](www.linkedin.com/in/alieldin190) · alyshaker2004@gmail.com
