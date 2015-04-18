﻿/*
Deployment script for charasparkprod

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "charasparkprod"
:setvar DefaultFilePrefix "charasparkprod"
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Creating [nobarrierswebsvc]...';


GO
CREATE SCHEMA [nobarrierswebsvc]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [yIjkgMHAdqLogin_nobarrierswebsvcUser]...';


GO
CREATE USER [yIjkgMHAdqLogin_nobarrierswebsvcUser] FOR LOGIN [yIjkgMHAdqLogin_nobarrierswebsvc]
    WITH DEFAULT_SCHEMA = [nobarrierswebsvc];


GO
REVOKE CONNECT TO [yIjkgMHAdqLogin_nobarrierswebsvcUser];


GO
PRINT N'Creating [dbo].[error_log]...';


GO
CREATE TABLE [dbo].[error_log] (
    [error_id]   INT           IDENTITY (1, 1) NOT NULL,
    [error_desc] VARCHAR (MAX) NULL,
    [error_date] DATETIME      NOT NULL,
    CONSTRAINT [PK_error_log] PRIMARY KEY CLUSTERED ([error_id] ASC)
);


GO
PRINT N'Creating [dbo].[users]...';


GO
CREATE TABLE [dbo].[users] (
    [user_id]     INT          IDENTITY (1, 1) NOT NULL,
    [first_name]  VARCHAR (20) NOT NULL,
    [middle_name] VARCHAR (20) NULL,
    [last_name]   VARCHAR (20) NOT NULL,
    [former_name] VARCHAR (20) NULL,
    [login_id]    VARCHAR (20) NOT NULL,
    [e_mail]      VARCHAR (50) NOT NULL,
    [create_date] DATETIME     NOT NULL,
    [created_by]  VARCHAR (50) NOT NULL,
    [update_date] DATETIME     NULL,
    [is_active]   BIT          NOT NULL,
    [is_donor]    BIT          NOT NULL,
    CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED ([user_id] ASC)
);


GO
PRINT N'Creating [dbo].[wish_status]...';


GO
CREATE TABLE [dbo].[wish_status] (
    [wish_status_id] INT          IDENTITY (1, 1) NOT NULL,
    [wish_status]    VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_wish_status] PRIMARY KEY CLUSTERED ([wish_status_id] ASC)
);


GO
PRINT N'Creating [dbo].[wishes]...';


GO
CREATE TABLE [dbo].[wishes] (
    [wish_id]        INT          IDENTITY (1, 1) NOT NULL,
    [wish_name]      VARCHAR (50) NOT NULL,
    [task_status_id] INT          NULL,
    [create_date]    DATETIME     NOT NULL,
    [created_by]     VARCHAR (50) NOT NULL,
    [update_date]    DATETIME     NULL,
    [is_active]      BIT          NOT NULL,
    [start_date]     DATETIME     NULL,
    [end_date]       DATETIME     NULL,
    [userid]         INT          NULL,
    CONSTRAINT [PK_wishes] PRIMARY KEY CLUSTERED ([wish_id] ASC)
);


GO
PRINT N'Creating [dbo].[DF_error_log_constraint]...';


GO
ALTER TABLE [dbo].[error_log]
    ADD CONSTRAINT [DF_error_log_constraint] DEFAULT (getdate()) FOR [error_date];


GO
PRINT N'Creating [dbo].[DF_users_create_date]...';


GO
ALTER TABLE [dbo].[users]
    ADD CONSTRAINT [DF_users_create_date] DEFAULT (getdate()) FOR [create_date];


GO
PRINT N'Creating [dbo].[DF_users_created_by]...';


GO
ALTER TABLE [dbo].[users]
    ADD CONSTRAINT [DF_users_created_by] DEFAULT (suser_sname()) FOR [created_by];


GO
PRINT N'Creating [dbo].[DF_tasks_create_date]...';


GO
ALTER TABLE [dbo].[wishes]
    ADD CONSTRAINT [DF_tasks_create_date] DEFAULT (getdate()) FOR [create_date];


GO
PRINT N'Creating [dbo].[DF_tasks_created_by]...';


GO
ALTER TABLE [dbo].[wishes]
    ADD CONSTRAINT [DF_tasks_created_by] DEFAULT (suser_sname()) FOR [created_by];


GO
PRINT N'Creating [dbo].[FK_wishes_users]...';


GO
ALTER TABLE [dbo].[wishes] WITH NOCHECK
    ADD CONSTRAINT [FK_wishes_users] FOREIGN KEY ([userid]) REFERENCES [dbo].[users] ([user_id]);


GO
PRINT N'Creating [dbo].[FK_wishes_wish_status]...';


GO
ALTER TABLE [dbo].[wishes] WITH NOCHECK
    ADD CONSTRAINT [FK_wishes_wish_status] FOREIGN KEY ([task_status_id]) REFERENCES [dbo].[wish_status] ([wish_status_id]);


GO
