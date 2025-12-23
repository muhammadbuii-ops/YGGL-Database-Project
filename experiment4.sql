-- 使用YGGL数据库
USE YGGL;
-- (1) 用SELECT语句查询Departments表的所有记录
SELECT * FROM Departments;
-- (2) 用SELECT语句查询Salary表的所有记录
SELECT * FROM Salary;
-- (3) 用SELECT语句查询Departments表的部门号和部门名称列
SELECT departmentID, departmentName FROM Departments;
-- (4) 查询Employees表中部门号和性别，要求使用DISTINCT消除重复行
SELECT DISTINCT DepartmentID, Sex FROM Employees;
-- (5) 查询月收入高于2000的员工号码
SELECT EmployeeID FROM Salary WHERE Income > 2000;
-- (6) 查询所有1970以后出生的员工的姓名和住址
SELECT Name, Address 
FROM Employees 
WHERE YEAR(Birthday) > 1970;
-- (7) 查询所有财务部门的员工号码和姓名
SELECT e.EmployeeID, e.Name 
FROM Employees e 
INNER JOIN Departments d ON e.DepartmentID = d.departmentID 
WHERE d.departmentName = '财务部';
-- (8) 查询Employees表中男员工的姓名和出生日期，要求各列标题用中文表示
SELECT Name AS '姓名', Birthday AS '出生日期' 
FROM Employees 
WHERE Sex = '1';

-- (9) 查询Employees员工的姓名、住址和收入水平，2000以下的显示为低收入，2000~3000的显示为中等收入，3000以上的显示为高收入
SELECT 
    e.Name AS '姓名',
    e.Address AS '住址',
    s.Income AS '收入',
    CASE 
        WHEN s.Income < 2000 THEN '低收入'
        WHEN s.Income BETWEEN 2000 AND 3000 THEN '中等收入'
        ELSE '高收入'
    END AS '收入水平'
FROM Employees e
INNER JOIN Salary s ON e.EmployeeID = s.EmployeeID;

-- (10) 计算Salary表中员工月收入的平均数
SELECT AVG(Income) AS '平均收入' FROM Salary;

-- (11) 获得Employees表中的最大的员工号码
SELECT MAX(EmployeeID) AS '最大员工号码' FROM Employees;

-- (12) 计算Salary表中所有员工的总支出
SELECT SUM(Outcome) AS '总支出' FROM Salary;

-- (13) 查询财务部员工的最高和最低实际收入
SELECT 
    MAX(s.Income - s.Outcome) AS '最高实际收入',
    MIN(s.Income - s.Outcome) AS '最低实际收入'
FROM Salary s
INNER JOIN Employees e ON s.EmployeeID = e.EmployeeID
INNER JOIN Departments d ON e.DepartmentID = d.departmentID
WHERE d.departmentName = '财务部';

-- (14) 找出所有其地址含有"中山"的雇员的号码及部门号
SELECT EmployeeID, DepartmentID 
FROM Employees 
WHERE Address LIKE '%中山%';

-- (15) 查找员工号码中倒数第二个数字为0的姓名、地址和学历
SELECT Name, Address, Education 
FROM Employees 
WHERE EmployeeID LIKE '%0_';

-- (16) 找出所有在部门"1"或"2"工作的雇员的号码
SELECT EmployeeID 
FROM Employees 
WHERE DepartmentID IN ('1', '2');

USE YGGL;
-- (1) 用子查询的方法查找所有收入在2500以下的雇员的情况
SELECT * 
FROM Employees 
WHERE EmployeeID IN (
    SELECT EmployeeID 
    FROM Salary 
    WHERE Income < 2500
);
-- (2) 用子查询的方法查找研发部比财务部所有雇员收入都高的雇员的姓名
SELECT e.Name
FROM Employees e
JOIN Salary s ON e.EmployeeID = s.EmployeeID
-- 正确：筛选研发部员工
WHERE e.DepartmentID = (SELECT departmentID FROM Departments WHERE departmentName = '研发部')
-- 收入高于财务部所有员工（即财务部最高收入）
AND s.Income > (
    SELECT MAX(s2.Income)
    FROM Employees e2
    JOIN Salary s2 ON e2.EmployeeID = s2.EmployeeID
    WHERE e2.DepartmentID = (SELECT departmentID FROM Departments WHERE departmentName = '财务部')
);

-- 定义变量存储部门ID
SET @dev_dept = (SELECT departmentID FROM Departments WHERE departmentName = '研发部');
SET @fin_dept = (SELECT departmentID FROM Departments WHERE departmentName = '财务部');

-- 查询研发部收入高于财务部最高收入的员工
SELECT e.Name
FROM Employees e
JOIN Salary s ON e.EmployeeID = s.EmployeeID
WHERE e.DepartmentID = @dev_dept
AND s.Income > (SELECT MAX(Income) FROM Salary WHERE EmployeeID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @fin_dept));


WITH 
FinMaxIncome AS (
    SELECT MAX(s.Income) AS max_income
    FROM Employees e
    JOIN Salary s ON e.EmployeeID = s.EmployeeID
    WHERE e.DepartmentID = (SELECT departmentID FROM Departments WHERE departmentName = '财务部')
),
DevEmployees AS (
    SELECT e.Name, s.Income
    FROM Employees e
    JOIN Salary s ON e.EmployeeID = s.EmployeeID
    WHERE e.DepartmentID = (SELECT departmentID FROM Departments WHERE departmentName = '研发部')
)
SELECT de.Name
FROM DevEmployees de
JOIN FinMaxIncome fmi
ON de.Income > fmi.max_income;

-- (3) 用子查询的方法查找年龄比研发部所有雇员年龄都大的雇员的姓名
SELECT Name 
FROM Employees 
WHERE Birthday < ALL (
    SELECT Birthday 
    FROM Employees 
    WHERE DepartmentID = (
        SELECT departmentID 
        FROM Departments 
        WHERE departmentName = '研发部'
    )
);

-- (1) 查询每个雇员的情况及其工作部门的情况
SELECT e.*, d.* 
FROM Employees e 
INNER JOIN Departments d ON e.DepartmentID = d.departmentID;

-- (2) 使用左连接的方法查找不在财务部工作的所有员工信息
SELECT e.*
FROM Employees e
LEFT JOIN Departments d ON e.departmentID = d.departmentID
WHERE d.departmentName != '财务部' 
   OR d.departmentName IS NULL; -- 包含无部门的员工
-- (3) 使用外连接方法查找所有员工的月收入
SELECT e.EmployeeID, e.Name, s.Income 
FROM Employees e 
LEFT JOIN Salary s ON e.EmployeeID = s.EmployeeID;

-- (4) 查询研发部在1966年以前出生的雇员姓名及其薪水详情
SELECT e.Name, s.Income, s.Outcome, (s.Income - s.Outcome) AS '实际收入'
FROM Employees e 
INNER JOIN Departments d ON e.DepartmentID = d.departmentID
INNER JOIN Salary s ON e.EmployeeID = s.EmployeeID
WHERE d.departmentName = '研发部' AND YEAR(e.Birthday) < 1966;

-- (1) 按部门列出在该部门工作的员工的人数
SELECT d.departmentName AS '部门名称', COUNT(e.EmployeeID) AS '员工人数'
FROM Departments d 
LEFT JOIN Employees e ON d.departmentID = e.DepartmentID
GROUP BY d.departmentID, d.departmentName;

-- (2) 按员工的学历分组，列出本科、大专和硕士的人数
SELECT Education AS '学历', COUNT(*) AS '人数'
FROM Employees
WHERE Education IN ('本科', '大专', '硕士')
GROUP BY Education;

-- (3) 按员工的工作年份分组，统计各个工作年份的人数
SELECT WorkYear AS '工作年份', COUNT(*) AS '人数'
FROM Employees
GROUP BY WorkYear
ORDER BY WorkYear;

-- (4) 将员工信息按出生日期从小到大排列
SELECT * 
FROM Employees 
ORDER BY Birthday;

-- (5) 在ORDER BY子句中使用子查询，查询员工姓名、性别和工龄信息，要求按实际收入从大到小排列
SELECT e.Name, e.Sex, e.WorkYear
FROM Employees e
ORDER BY (
    SELECT (s.Income - s.Outcome)
    FROM Salary s
    WHERE s.EmployeeID = e.EmployeeID
) DESC;

-- (6) 返回Employees表中从第3位员工开始的5个员工的信息
SELECT * 
FROM Employees 
ORDER BY EmployeeID ASC  -- 按员工ID升序，保证顺序稳定
LIMIT 2, 5;

-- (1) 创建YGGL数据库上的视图DS_VIEW，视图包含Departments表的全部列
CREATE VIEW DS_VIEW AS
SELECT * FROM Departments;

-- (2) 创建YGGL数据库上的视图Employees_view，视图包含员工号码、姓名和实际收入
CREATE VIEW Employees_view AS
SELECT 
    e.EmployeeID AS '员工号码',
    e.Name AS '姓名',
    (s.Income - s.Outcome) AS '实际收入'
FROM Employees e
LEFT JOIN Salary s ON e.EmployeeID = s.EmployeeID;