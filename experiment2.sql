-- 显示当前在用数据库
SELECT DATABASE();
-- 删除已存在的YGGL数据库（如果存在）
DROP DATABASE IF EXISTS YGGL;
-- 创建数据库YGGL，字符集为utf8，校对规则为utf8_general_ci
CREATE DATABASE YGGL 
CHARACTER SET utf8 
COLLATE utf8_general_ci;
-- 使用YGGL数据库
USE YGGL;
-- 首先创建Departments表（被Employees表外键引用）
CREATE TABLE IF NOT EXISTS Departments (
    departmentID CHAR(3) NOT NULL,        -- 部门编号，固定3字符，非空
    departmentName CHAR(20) NOT NULL,     -- 部门名称，固定20字符，非空
    note TEXT,                            -- 备注，长文本，可为空
    PRIMARY KEY (departmentID)            -- 设置departmentID为主键
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
--  创建Employees表（引用Departments，被Salary引用）
CREATE TABLE IF NOT EXISTS Employees (
    EmployeeID CHAR(6) NOT NULL,          -- 员工编号，固定6字符，非空
    Name CHAR(10) NOT NULL,               -- 姓名，固定10字符，非空
    Education CHAR(4) NOT NULL,           -- 学历，固定4字符，非空
    Birthday DATE NOT NULL,               -- 出生日期，日期类型，非空
    Sex CHAR(2) NOT NULL,                 -- 性别，固定2字符，非空
    WorkYear TINYINT,                     -- 工龄，微小整数，可为空
    Address VARCHAR(20),                  -- 地址，可变长字符串（最大20），可为空
    PhoneNumber CHAR(12),                 -- 电话，固定12字符，可为空
    DepartmentID CHAR(3) NOT NULL,        -- 所属部门编号，非空
    PRIMARY KEY (EmployeeID),             -- 设置EmployeeID为主键
    FOREIGN KEY (DepartmentID) 
        REFERENCES Departments(departmentID)
        ON DELETE RESTRICT                -- 禁止删除被引用的部门
        ON UPDATE CASCADE                 -- 部门编号更新时，同步更新此处
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- 创建Salary表（引用Employees）
CREATE TABLE IF NOT EXISTS Salary (
    EmployeeID CHAR(6) NOT NULL,          -- 员工编号，固定6字符，非空
    Income FLOAT NOT NULL,                -- 收入，浮点数，非空
    Outcome FLOAT NOT NULL,               -- 支出，浮点数，非空
    PRIMARY KEY (EmployeeID),             -- 设置EmployeeID为主键
    FOREIGN KEY (EmployeeID) 
        REFERENCES Employees(EmployeeID)
        ON DELETE CASCADE                 -- 删除员工时，同步删除其薪水记录
        ON UPDATE CASCADE                 -- 员工编号更新时，同步更新此处
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- 显示当前使用的数据库
SELECT DATABASE();
-- 显示所有表
SHOW TABLES;
-- 显示表结构
DESC Departments;
DESC Employees;
DESC Salary;