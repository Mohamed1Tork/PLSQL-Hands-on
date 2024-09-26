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
