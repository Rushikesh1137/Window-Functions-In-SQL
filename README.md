# SQL Window Functions

This repository provides a guide on SQL window functions, which are powerful tools that allow you to perform calculations across a set of table rows related to the current row, without collapsing the result into a single output row. Window functions can be used for tasks like ranking, calculating running totals, and more.

- **Key Concepts**: Understand how window functions differ from standard aggregates.
- **Real-World Datasets**: Work with practical datasets focusing on `ROW_NUMBER`, `RANK`, `LEAD`, and `LAG`.
- **Hands-On Problems with solutions**: Solve curated challenges from basic to advanced levels.



---

### Syntax of Window Functions:


```sql
<window_function> OVER (
    PARTITION BY <column1>, <column2>, ...
    ORDER BY <column1> [ASC|DESC], <column2> [ASC|DESC], ...
    ROWS BETWEEN <range> 
)
```

<window_function>: This is the type of window function you are using (e.g., ROW_NUMBER(), RANK(), AVG(), SUM(), LEAD(), LAG(), etc.).

PARTITION BY: This clause divides the result set into partitions or groups. The window function is applied to each partition separately. If you don't need partitioning, you can omit this clause.

ORDER BY: This defines the order in which the function is applied to the rows within each partition.

ROWS BETWEEN: This clause is optional and specifies the range of rows in the window. By default, it considers all rows from the first row to the current row.



## Types of Window Functions

### 1. **Ranking Functions**

These functions assign ranks to rows within a partition. They are used when you need to rank data, such as by sales amount or date.

#### **ROW_NUMBER()**

Assigns a unique number to each row, starting from 1 for each partition.

```sql
ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC)
```

#### **RANK()**

 Assigns a rank to each row, with gaps in ranking for ties.
 
```sql
RANK() OVER (PARTITION BY department ORDER BY salary DESC)
```

#### **DENSE_RANK()**

Similar to RANK(), but without gaps in the ranking for ties.
 
```sql
DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC)
```


### 2. **Aggregate Functions**

These functions calculate aggregates over a window of rows, rather than collapsing rows into a single output.


#### **SUM()**

Calculates the sum of a column over a window.

```sql
SUM(sales_amount) OVER (PARTITION BY region ORDER BY sale_date)
```

#### **AVG()**

Calculates the average of a column over a window.

```sql
AVG(sales_amount) OVER (PARTITION BY region ORDER BY sale_date)
```
#### **MIN()**

Calculates the Minimum of a column over a window. 

```sql
MIN(sales_amount) OVER (PARTITION BY region ORDER BY sale_date)
```
#### **MAX()**

Calculates the Maximum of a column over a window. 

```sql
MAX(sales_amount) OVER (PARTITION BY region ORDER BY sale_date)
```


### 3. **OFFSET Functions**

These functions allow you to access data from preceding or following rows in the result set.

#### **LEAD()**

Returns the value of a column from the next row (i.e., look ahead).

```sql
LEAD(sales_amount, 1) OVER (PARTITION BY region ORDER BY sale_date)
```

#### **LAG()**

Returns the value of a column from the previous row (i.e., look back).

```sql
LAG(sales_amount, 1) OVER (PARTITION BY region ORDER BY sale_date)
```

