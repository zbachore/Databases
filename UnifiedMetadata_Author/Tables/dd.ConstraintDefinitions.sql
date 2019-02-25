CREATE TABLE [dd].[ConstraintDefinitions]
(
[ConstraintDefinitionId] [int] NOT NULL IDENTITY(1, 1),
[ConstraintTypeId] [int] NOT NULL,
[ConstraintReportingLevelId] [int] NOT NULL,
[ConstraintDefinitionName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConstraintDefinitionDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IntValue] [int] NULL,
[StringValue] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UnitOfMeasureId] [int] NULL,
[DecimalValue] [decimal] (18, 6) NULL,
[RegistryElementId] [int] NULL,
[ConstraintDefinitionCode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConstraintDefinitionMessage] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Operator] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BooleanValue] [bit] NULL,
[ConstraintDefinitionScopeId] [int] NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ConstraintDefinitions_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ConstraintDefinitions_UpdatedDate] DEFAULT (sysdatetime()),
[DateValue] [datetime2] NULL,
[IsNullValue] [bit] NULL,
[IsQC] [bit] NOT NULL CONSTRAINT [DF_ConstraintDefinitions_IsQC] DEFAULT ((0)),
[IsDQR] [bit] NOT NULL CONSTRAINT [DF_ConstraintDefinitions_IsDQR] DEFAULT ((0)),
[IsCA] [bit] NOT NULL CONSTRAINT [DF_ConstraintDefinitions_IsCA] DEFAULT ((0))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dd].[ConstraintDefinitions] ADD CONSTRAINT [PK_ConstraintDefinitions] PRIMARY KEY CLUSTERED  ([ConstraintDefinitionId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ConstraintDefinitions_ConstraintReportingLevels] ON [dd].[ConstraintDefinitions] ([ConstraintReportingLevelId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ConstraintDefinitions_ConstraintTypes] ON [dd].[ConstraintDefinitions] ([ConstraintTypeId]) ON [PRIMARY]
GO
