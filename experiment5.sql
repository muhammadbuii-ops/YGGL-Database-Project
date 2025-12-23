-- (1) 从视图DS_VIEW中查询出部门号为3的部门名称
SELECT departmentName 
FROM DS_VIEW 
WHERE departmentID = '3';

-- (2) 从视图Employees_view查询出姓名为"王林"的员工的实际收入
SELECT `实际收入`
FROM Employees_view
WHERE `姓名` = '王林';

-- (1) 向视图DS_VIEW中插入一行数据：6，广告部，广告业务
INSERT INTO DS_VIEW (departmentID, departmentName, note) 
VALUES ('6', '广告部', '广告业务');

-- (2) 查看视图DS_VIEW和基本表Departments的变化
SELECT * FROM DS_VIEW;
SELECT * FROM Departments;

-- (3) 尝试向视图Employees_view中插入一行数据
-- 注意：这个视图包含连接和计算列，可能不允许插入
-- INSERT INTO Employees_view VALUES ('999999', '测试员工', 5000);

-- (4) 修改视图DS_VIEW，将部门号为5的部门名称修改为"生产车间"
UPDATE DS_VIEW 
SET departmentName = '生产车间' 
WHERE departmentID = '5';

-- (5) 查看视图DS_VIEW和基本表Departments的变化
SELECT * FROM DS_VIEW WHERE departmentID = '5';
SELECT * FROM Departments WHERE departmentID = '5';

-- (6) 修改视图Employees_view中号码为000001的雇员的姓名为"王浩"
UPDATE Employees 
SET Name = '王浩' 
WHERE EmployeeID = '000001';

-- 删除视图DS_VIEW
DROP VIEW IF EXISTS DS_VIEW;