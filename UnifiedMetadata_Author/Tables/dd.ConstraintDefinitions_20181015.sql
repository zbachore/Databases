CREATE TABLE [dd].[ConstraintDefinitions_20181015]
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
[CreatedDate] [datetime2] NOT NULL,
[UpdatedDate] [datetime2] NOT NULL,
[DateValue] [datetime2] NULL,
[IsNullValue] [bit] NULL,
[IsQC] [bit] NOT NULL,
[IsDQR] [bit] NOT NULL,
[IsCA] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
