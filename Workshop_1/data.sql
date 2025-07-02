-- Tạo database nếu chưa tồn tại
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'StartupProjectManagement')
BEGIN
    CREATE DATABASE StartupProjectManagement;
END
GO

USE StartupProjectManagement;
GO

-- Tạo bảng tblUsers nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'tblUsers')
BEGIN
    CREATE TABLE tblUsers (
        Username VARCHAR(50) PRIMARY KEY,
        Name VARCHAR(100) NOT NULL,
        Password VARCHAR(255) NOT NULL,
        Role VARCHAR(20) NOT NULL,
        CONSTRAINT chk_UserRole CHECK (Role IN ('Founder', 'Team Member'))
    );
END
GO

-- Tạo bảng tblStartupProjects nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'tblStartupProjects')
BEGIN
    CREATE TABLE tblStartupProjects (
        project_id INT IDENTITY(1,1) PRIMARY KEY,
        project_name VARCHAR(100) NOT NULL,
        Description TEXT NULL,
        Status VARCHAR(20) NOT NULL,
        estimated_launch DATE NOT NULL,
        CONSTRAINT chk_ProjectStatus CHECK (Status IN ('Ideation', 'Development', 'Launch', 'Scaling'))
    );
END
GO

-- Chèn dữ liệu (chỉ khi chưa tồn tại)
IF NOT EXISTS (SELECT * FROM tblUsers WHERE Username = 'admin')
BEGIN
    INSERT INTO tblUsers (Username, Name, Password, Role)
    VALUES ('Founder', 'Founder', '12345', 'Founder');
END

IF NOT EXISTS (SELECT * FROM tblUsers WHERE Username = 'TranAnhVu')
BEGIN
    INSERT INTO tblUsers (Username, Name, Password, Role)
    VALUES ('TranAnhVu', 'Tran Anh Vu', '12345', 'Team Member');
END

IF NOT EXISTS (SELECT * FROM tblUsers WHERE Username = 'NguyenDuyTung')
BEGIN
    INSERT INTO tblUsers (Username, Name, Password, Role)
    VALUES ('NguyenDuyTung', 'Nguyen Duy Tung', '12345', 'Team Member');
END
GO