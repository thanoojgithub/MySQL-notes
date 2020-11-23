-- 2nd maximum salary
-----------------------------------------------------------------------------------------------
TOP, LIMIT, ROW_NUMBER(), RANK(), and DENSE_RANK()


mysql> CREATE TABLE Employee (id INT, name VARCHAR(30), salary INT);
Query OK, 0 rows affected (0.06 sec)

mysql> INSERT INTO Employee (id, name, salary) VALUES (1,'ram',20000);
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO Employee (id, name, salary) VALUES (2,'sita',18000);
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO Employee (id, name, salary) VALUES (3,'hanuma',10000);
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO Employee (id, name, salary) VALUES (4,'lak',15000);
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO Employee (id, name, salary) VALUES (5,'bharat',12000);
Query OK, 1 row affected (0.01 sec)
   
mysql> INSERT INTO Employee (id, name, salary) VALUES (6,'savitri',18000);
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO Employee (id, name, salary) VALUES (7,'sun',22000);
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO Employee (id, name, salary) VALUES (8,'sugriva',11000);
Query OK, 1 row affected (0.02 sec)

mysql> select * from Employee order by salary desc;
+------+---------+--------+------+
| id   | name    | salary | mgr  |
+------+---------+--------+------+
|    7 | sun     |  22000 | NULL |
|    1 | ram     |  20000 | NULL |
|    2 | sita    |  18000 | NULL |
|    6 | savitri |  18000 | NULL |
|    4 | lak     |  15000 | NULL |
|    5 | bharat  |  12000 | NULL |
|    8 | sugriva |  11000 | NULL |
|    3 | hanuma  |  10000 | NULL |
+------+---------+--------+------+
8 rows in set (0.00 sec)


mysql> SELECT MAX(salary) FROM Employee WHERE Salary NOT IN ( SELECT Max(Salary) FROM Employee);
+-------------+
| MAX(salary) |
+-------------+
|       18000 |
+-------------+
1 row in set (0.00 sec)

mysql> SELECT MAX(salary) FROM Employee WHERE Salary < ( SELECT Max(Salary) FROM Employee);
+-------------+
| MAX(salary) |
+-------------+
|       18000 |
+-------------+
1 row in set (0.00 sec)

mysql> SELECT Salary FROM (SELECT Salary FROM Employee ORDER BY salary DESC LIMIT 2) AS Emp ORDER BY salary LIMIT 1;
+--------+
| Salary |
+--------+
|  18000 |
+--------+
1 row in set (0.00 sec)


--The difference between RANK(), DENSE_RANK() and ROW_NUMBER() boils down to:

--ROW_NUMBER() always generates a unique ranking; if the ORDER BY clause cannot distinguish between two rows, it will still give them different rankings (randomly)
--RANK() and DENSE_RANK() will give the same ranking to rows that cannot be distinguished by the ORDER BY clause
--DENSE_RANK() will always generate a contiguous sequence of ranks (1,2,3,...), whereas RANK() will leave gaps after two or more rows with 	the same rank (think "Olympic Games": if two athletes win the gold medal, there is no second place, only third)

mysql> select name,salary, row_number() over(order by salary desc) as rank_id from Employee;
+---------+--------+---------+
| name    | salary | rank_id |
+---------+--------+---------+
| ram     |  20000 |       1 |
| sita    |  18000 |       2 |
| savitri |  18000 |       3 |
| lak     |  15000 |       4 |
| bharat  |  12000 |       5 |
| hanuma  |  10000 |       6 |
+---------+--------+---------+
6 rows in set (0.00 sec)

mysql> select name,salary, rank() over(order by salary desc) as rank_id from Employee;
+---------+--------+---------+
| name    | salary | rank_id |
+---------+--------+---------+
| ram     |  20000 |       1 |
| sita    |  18000 |       2 |
| savitri |  18000 |       2 |
| lak     |  15000 |       4 |
| bharat  |  12000 |       5 |
| hanuma  |  10000 |       6 |
+---------+--------+---------+
6 rows in set (0.00 sec)

mysql> select name,salary, dense_rank() over(order by salary desc) as rank_id from Employee;
+---------+--------+---------+
| name    | salary | rank_id |
+---------+--------+---------+
| ram     |  20000 |       1 |
| sita    |  18000 |       2 |
| savitri |  18000 |       2 |
| lak     |  15000 |       3 |
| bharat  |  12000 |       4 |
| hanuma  |  10000 |       5 |
+---------+--------+---------+
6 rows in set (0.00 sec)

mysql> 



mysql> select name, salary from (select name,salary, row_number() over(order by salary desc) as rank_id from Employee) a where rank_id=2;
+------+--------+
| name | salary |
+------+--------+
| sita |  18000 |
+------+--------+
1 row in set (0.00 sec)

mysql> select name, salary from (select name,salary, dense_rank() over(order by salary desc) as rank_id from Employee) a where rank_id=2;
+---------+--------+
| name    | salary |
+---------+--------+
| sita    |  18000 |
| savitri |  18000 |
+---------+--------+
2 rows in set (0.00 sec)

mysql> select name, salary from (select name,salary, rank() over(order by salary desc) as rank_id from Employee) a where rank_id=2;
+---------+--------+
| name    | salary |
+---------+--------+
| sita    |  18000 |
| savitri |  18000 |
+---------+--------+
2 rows in set (0.00 sec)

mysql> 



-- list out only Duplicate list:
-------------------------------------------------------------------------------------------------
mysql> select id, name, e1.salary from Employee e1 INNER JOIN (select salary from Employee group by salary having count(id) > 1) e2 on e1.salary=e2.salary;
+------+---------+--------+
| id   | name    | salary |
+------+---------+--------+
|    2 | sita    |  18000 |
|    6 | savitri |  18000 |
+------+---------+--------+
2 rows in set (0.00 sec)

mysql> 


mysql> select id, name, e1.salary from Employee e1 INNER JOIN (select salary from Employee group by salary having count(id) > 1) e2 on e1.salary
<> e2.salary;
+------+--------+--------+
| id   | name   | salary |
+------+--------+--------+
|    5 | bharat |  12000 |
|    4 | lak    |  15000 |
|    3 | hanuma |  10000 |
|    1 | ram    |  20000 |
+------+--------+--------+
4 rows in set (0.00 sec)

mysql> select id, name, e1.salary from Employee e1 INNER JOIN (select salary from Employee group by salary having count(id) = 1) e2 on e1.salary
= e2.salary;
+------+--------+--------+
| id   | name   | salary |
+------+--------+--------+
|    1 | ram    |  20000 |
|    3 | hanuma |  10000 |
|    4 | lak    |  15000 |
|    5 | bharat |  12000 |
+------+--------+--------+
4 rows in set (0.01 sec)

mysql> 

mysql> EXPLAIN select id, name, e1.salary from Employee e1 INNER JOIN (select salary from Employee group by salary having count(id) = 1) e2 on e1
.salary = e2.salary;
+----+-------------+------------+------------+------+---------------+-------------+---------+----------------+------+----------+-----------------+
| id | select_type | table      | partitions | type | possible_keys | key         | key_len | ref            | rows | filtered | Extra           |
+----+-------------+------------+------------+------+---------------+-------------+---------+----------------+------+----------+-----------------+
|  1 | PRIMARY     | e1         | NULL       | ALL  | NULL          | NULL        | NULL    | NULL           |    6 |   100.00 | Using where     |
|  1 | PRIMARY     | <derived2> | NULL       | ref  | <auto_key0>   | <auto_key0> | 5       | mydb.e1.salary |    2 |   100.00 | Using index     |
|  2 | DERIVED     | Employee   | NULL       | ALL  | NULL          | NULL        | NULL    | NULL           |    6 |   100.00 | Using temporary |
+----+-------------+------------+------------+------+---------------+-------------+---------+----------------+------+----------+-----------------+
3 rows in set, 1 warning (0.00 sec)

mysql> EXPLAIN select id, name, e1.salary from Employee e1 INNER JOIN (select salary from Employee group by salary having count(id) > 1) e2 on e1
.salary <> e2.salary;
+----+-------------+------------+------------+------+---------------+------+---------+------+------+----------+--------------------------------------------+
| id | select_type | table      | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra                                      |
+----+-------------+------------+------------+------+---------------+------+---------+------+------+----------+--------------------------------------------+
|  1 | PRIMARY     | e1         | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    6 |   100.00 | NULL                                       |
|  1 | PRIMARY     | <derived2> | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    6 |    83.33 | Using where; Using join buffer (hash join) |
|  2 | DERIVED     | Employee   | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    6 |   100.00 | Using temporary                            |
+----+-------------+------------+------------+------+---------------+------+---------+------+------+----------+--------------------------------------------+
3 rows in set, 1 warning (0.00 sec)

mysql> ALTER TABLE Employee ADD COLUMN mgr INT AFTER salary;
Query OK, 0 rows affected (0.04 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> UPDATE Employee set mgr=1 where id in (2,4,5);
Query OK, 0 rows affected (0.00 sec)
Rows matched: 3  Changed: 0  Warnings: 0

mysql> select * from Employee order by salary desc;
+------+---------+--------+------+
| id   | name    | salary | mgr  |
+------+---------+--------+------+
|    7 | sun     |  22000 | NULL |
|    1 | ram     |  20000 |    7 |
|    2 | sita    |  18000 |    1 |
|    6 | savitri |  18000 | NULL |
|    4 | lak     |  15000 |    1 |
|    5 | bharat  |  12000 |    1 |
|    8 | sugriva |  11000 |    1 |
|    3 | hanuma  |  10000 |    8 |
+------+---------+--------+------+
8 rows in set (0.00 sec)

mysql> 




-- Manager
------------------------------------------------------------------------------------------------------
mysql> SELECT e.name, e.id, m.name as manager, e.mgr FROM Employee e, Employee m WHERE e.mgr = m.id;
+---------+------+---------+------+
| name    | id   | manager | mgr  |
+---------+------+---------+------+
| sugriva |    8 | ram     |    1 |
| bharat  |    5 | ram     |    1 |
| lak     |    4 | ram     |    1 |
| sita    |    2 | ram     |    1 |
| ram     |    1 | sun     |    7 |
| hanuma  |    3 | sugriva |    8 |
+---------+------+---------+------+
6 rows in set (0.00 sec)




mysql> SELECT e.name, e.id, m.name as manager, e.mgr FROM Employee e LEFT JOIN Employee m ON e.mgr = m.id;
+---------+------+---------+------+
| name    | id   | manager | mgr  |
+---------+------+---------+------+
| ram     |    1 | sun     |    7 |
| sita    |    2 | ram     |    1 |
| hanuma  |    3 | sugriva |    8 |
| lak     |    4 | ram     |    1 |
| bharat  |    5 | ram     |    1 |
| savitri |    6 | NULL    | NULL |
| sun     |    7 | NULL    | NULL |
| sugriva |    8 | ram     |    1 |
+---------+------+---------+------+
8 rows in set (0.00 sec)

mysql> 


