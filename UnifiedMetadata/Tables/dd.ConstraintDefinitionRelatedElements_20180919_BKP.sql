CREATE TABLE [dd].[ConstraintDefinitionRelatedElements_20180919_BKP]
(
[ConstraintDefinitionRelatedElementId] [int] NOT NULL,
[ConstraintDefinitionId] [int] NOT NULL,
[RegistryElementId] [int] NOT NULL,
[IntValue] [int] NULL,
[DecimalValue] [decimal] (10, 2) NULL,
[IsNullValue] [bit] NULL,
[CreatedDate] [datetime2] NOT NULL,
[UpdatedDate] [datetime2] NOT NULL,
[UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Operator] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StringValue] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayOrder] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
