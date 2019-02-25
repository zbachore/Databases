CREATE TABLE [rdd].[RegistryElementThresholds_20171127_wt]
(
[RegistryElementThresholdId] [int] NOT NULL IDENTITY(1, 1),
[RegistryElementId] [int] NOT NULL,
[Threshold] [int] NOT NULL,
[CompositeId] [int] NOT NULL,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NULL,
[RegistryVersionId] [int] NOT NULL,
[UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] (3) NOT NULL,
[UpdatedDate] [datetime2] (3) NOT NULL,
[FormSectionId] [int] NULL,
[FormPageId] [int] NULL
) ON [PRIMARY]
GO
