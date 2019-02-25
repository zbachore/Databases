CREATE TABLE [dbo].[Assay Device spreadsheet]
(
[Device_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Device_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Device_Subtype__99th_Percentile] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Device_Manufacturer] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Device_ID] [int] NOT NULL,
[Effective_date] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Expiration_date] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
