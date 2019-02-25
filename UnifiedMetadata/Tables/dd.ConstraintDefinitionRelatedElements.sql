CREATE TABLE [dd].[ConstraintDefinitionRelatedElements]
(
[ConstraintDefinitionRelatedElementId] [int] NOT NULL,
[ConstraintDefinitionId] [int] NOT NULL,
[RegistryElementId] [int] NOT NULL,
[IntValue] [int] NULL,
[DecimalValue] [decimal] (10, 2) NULL,
[IsNullValue] [bit] NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ConstraintDefinitionRelatedElements_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ConstraintDefinitionRelatedElements_UpdatedDate] DEFAULT (sysdatetime()),
[UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Operator] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StringValue] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayOrder] [int] NULL,
[ConstraintDefinitionRelatedElementGroupId] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dd].[ConstraintDefinitionRelatedElements] ADD CONSTRAINT [PK_ConstraintDefinitionRelatedElements] PRIMARY KEY CLUSTERED  ([ConstraintDefinitionRelatedElementId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ConstraintDefinitionRelatedElements_ConstraintDefinitions] ON [dd].[ConstraintDefinitionRelatedElements] ([ConstraintDefinitionId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ConstraintDefinitionRelatedElements_RegistryElements] ON [dd].[ConstraintDefinitionRelatedElements] ([RegistryElementId]) ON [PRIMARY]
GO
ALTER TABLE [dd].[ConstraintDefinitionRelatedElements] ADD CONSTRAINT [FK_ConstraintDefinitionRelatedElements_ConstraintDefinitionRelatedElementGroups] FOREIGN KEY ([ConstraintDefinitionRelatedElementGroupId]) REFERENCES [dd].[ConstraintDefinitionRelatedElementGroups] ([ConstraintDefinitionRelatedElementGroupId])
GO
ALTER TABLE [dd].[ConstraintDefinitionRelatedElements] ADD CONSTRAINT [FK_ConstraintDefinitionRelatedElements_ConstraintDefinitions] FOREIGN KEY ([ConstraintDefinitionId]) REFERENCES [dd].[ConstraintDefinitions] ([ConstraintDefinitionId])
GO
ALTER TABLE [dd].[ConstraintDefinitionRelatedElements] ADD CONSTRAINT [FK_ConstraintDefinitionRelatedElements_RegistryElements] FOREIGN KEY ([RegistryElementId]) REFERENCES [rdd].[RegistryElements] ([RegistryElementId])
GO
