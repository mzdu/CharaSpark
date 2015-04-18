﻿/*
Deployment script for charsparkqa

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "charsparkqa"
:setvar DefaultFilePrefix "charsparkqa"
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
/*
The column [dbo].[wishes].[task_status_id] is being dropped, data loss could occur.
*/

IF EXISTS (select top 1 1 from [dbo].[wishes])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'Dropping [dbo].[DF_tasks_create_date]...';


GO
ALTER TABLE [dbo].[wishes] DROP CONSTRAINT [DF_tasks_create_date];


GO
PRINT N'Dropping [dbo].[DF_tasks_created_by]...';


GO
ALTER TABLE [dbo].[wishes] DROP CONSTRAINT [DF_tasks_created_by];


GO
PRINT N'Dropping [dbo].[FK_wishes_users]...';


GO
ALTER TABLE [dbo].[wishes] DROP CONSTRAINT [FK_wishes_users];


GO
PRINT N'Dropping [dbo].[FK_wishes_wish_status]...';


GO
ALTER TABLE [dbo].[wishes] DROP CONSTRAINT [FK_wishes_wish_status];


GO
PRINT N'Starting rebuilding table [dbo].[wishes]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_wishes] (
    [wish_id]        INT          IDENTITY (1, 1) NOT NULL,
    [wish_name]      VARCHAR (50) NOT NULL,
    [wish_status_id] INT          NULL,
    [create_date]    DATETIME     CONSTRAINT [DF_tasks_create_date] DEFAULT (getdate()) NOT NULL,
    [created_by]     VARCHAR (50) CONSTRAINT [DF_tasks_created_by] DEFAULT (suser_sname()) NOT NULL,
    [update_date]    DATETIME     NULL,
    [is_active]      BIT          NOT NULL,
    [start_date]     DATETIME     NULL,
    [end_date]       DATETIME     NULL,
    [userid]         INT          NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_wishes] PRIMARY KEY CLUSTERED ([wish_id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[wishes])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_wishes] ON;
        INSERT INTO [dbo].[tmp_ms_xx_wishes] ([wish_id], [wish_name], [create_date], [created_by], [update_date], [is_active], [start_date], [end_date], [userid])
        SELECT   [wish_id],
                 [wish_name],
                 [create_date],
                 [created_by],
                 [update_date],
                 [is_active],
                 [start_date],
                 [end_date],
                 [userid]
        FROM     [dbo].[wishes]
        ORDER BY [wish_id] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_wishes] OFF;
    END

DROP TABLE [dbo].[wishes];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_wishes]', N'wishes';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_wishes]', N'PK_wishes', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[FK_wishes_users]...';


GO
ALTER TABLE [dbo].[wishes] WITH NOCHECK
    ADD CONSTRAINT [FK_wishes_users] FOREIGN KEY ([userid]) REFERENCES [dbo].[users] ([user_id]);


GO
PRINT N'Creating [dbo].[FK_wishes_wish_status]...';


GO
ALTER TABLE [dbo].[wishes] WITH NOCHECK
    ADD CONSTRAINT [FK_wishes_wish_status] FOREIGN KEY ([wish_status_id]) REFERENCES [dbo].[wish_status] ([wish_status_id]);


GO
PRINT N'Creating Permission...';


GO
GRANT CONTROL
    ON SCHEMA::[nobarrierswebsvc] TO [yIjkgMHAdqLogin_nobarrierswebsvcUser];


GO
