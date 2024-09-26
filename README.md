# PL/SQl Hands-on

### PL/SQL Project1: Sequence and Trigger Generation Script

----------

#### Project Description:

This PL/SQL project automates the creation of sequence-trigger pairs for all tables in a schema. It ensures that each table has a sequence starting from the maximum primary key value + 1, with triggers to automatically increment the primary key upon each insert. The project handles dropping existing sequences and replacing triggers where applicable, while ignoring non-numeric or composite primary keys.

----------

### Steps the Script Will Perform:

1.  **Drop Existing Sequences:**
    -   The script begins by looping through all tables in the schema and drops any existing sequences for each table.
2.  **Create New Sequences and Triggers:**
    -   For each table:
        -   If a numeric primary key exists, a new sequence is created.
        -   The sequence will start from the maximum value of the primary key column + 1.
        -   The script will ignore composite keys or non-numeric primary keys.
        -   A trigger is created (or replaced) to automatically populate the primary key using the sequence during `INSERT` operations.
3.  **Constraints:**
    -   Sequences will always increment by 1.
    -   Any existing triggers are replaced with new ones to ensure they align with the sequence behavior.

----------

### Script Components:

#### 1. **Sequence and Trigger Drop Logic:**

-   Drops any existing sequence associated with the table to avoid duplication.

#### 2. **Primary Key Detection:**

-   The script identifies the primary key column for each table and checks whether it is numeric.
-   The script skips any table where the primary key is composite or not numeric.

#### 3. **Dynamic SQL for Sequence and Trigger Creation:**

-   A dynamic SQL block is used to create sequences and triggers, allowing flexibility in applying the logic to all tables in the schema.
- ----------

### Additional Notes:

-   **Composite Primary Keys**: The script is designed to ignore tables with composite primary keys, as these cannot be easily managed by a single sequence.
-   **Non-Numeric Primary Keys**: Tables with non-numeric primary keys are skipped, as sequences are only applicable to numeric columns.
-   **Schema Flexibility**: The script can be adjusted to target different schemas by modifying the `owner` condition in the cursor.

----------

This project simplifies the maintenance of sequence-trigger pairs for large schemas, ensuring that sequences are always in sync with the highest primary key values in each table.

-------

### PL/SQL Project2: Data Integration Project

#### Project Overview

This PL/SQL project automates the process of reading employee data from an Excel sheet, loading it into a staging table in TOAD, and then validating, updating, or inserting the data into existing database tables. The following tables are involved in the database schema:

-   `employees`
-   `locations`
-   `departments`
-   `jobs`

#### Objective

The project reads employee data from an Excel sheet and integrates it into the database. Specifically, it:

1.  Loads the Excel data into a staging table.
2.  Validates the data.
3.  Updates or inserts data into the respective tables (`employees`, `locations`, `departments`, and `jobs`).

The project uses stored procedures to handle various update and insert operations.

----------

#### Project Steps

##### 1. **Loading Excel Data into TOAD**

-   The data from the Excel sheet is imported into a **staging table** using TOAD.
-   This staging table will serve as the temporary data source for processing.

##### 2. **Validation and Update/Insert Logic**

The following operations are handled using PL/SQL procedures:

1.  **Procedure to Add Cities (if they do not exist in the `locations` table)**:
    
    -   This procedure checks whether the city data from the staging table exists in the `locations` table. If not, it inserts the city into `locations`.
2.  **Procedure to Add Jobs (if they do not exist in the `jobs` table)**:
    
    -   This procedure checks for jobs from the staging data. If the job does not exist in the `jobs` table, it is inserted.
3.  **Procedure to Add Departments (if they do not exist in the `departments` table)**:
    
    -   This procedure checks for departments from the staging data. If the department does not exist in the `departments` table, it is inserted.
4.  **Procedure to Add or Update Employees in the `employees` table**:
    
    -   This procedure handles both updating existing employees (if found) and inserting new employees (if not found) based on the staging data.
-----
#### Usage

1.  **Import the Excel Sheet**:
    
    -   Open TOAD and import the Excel sheet into the `staging_employees` table.
2.  **Execute the PL/SQL Procedures**:
    
    -   Run the provided PL/SQL script that invokes the procedures to update or insert data into the relevant tables.
