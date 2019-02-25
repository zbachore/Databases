CREATE TABLE [cdd].[DataElementConstraintDefinitions]
(
[DataElementId] [int] NOT NULL,
[ConstraintDefinitionId] [int] NOT NULL,
[DataElementConstraintDefinitionsID] [int] NOT NULL IDENTITY(1, 1),
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DataElementConstraintDefinitions_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DataElementConstraintDefinitions_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[DataElementConstraintDefinitions] ADD CONSTRAINT [PK_DataElementId_ConstraintDefinitionId] PRIMARY KEY CLUSTERED  ([DataElementConstraintDefinitionsID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_DataElements_ConstraintDefinitions_ConstraintDefinitions] ON [cdd].[DataElementConstraintDefinitions] ([ConstraintDefinitionId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[DataElementConstraintDefinitions] ADD CONSTRAINT [U_DataElements_ConstraintDefinitions_ConstraintDefinitionId] UNIQUE NONCLUSTERED  ([ConstraintDefinitionId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[DataElementConstraintDefinitions] ADD CONSTRAINT [U_DataElementConstraintDefinitions] UNIQUE NONCLUSTERED  ([ConstraintDefinitionId], [DataElementId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_DataElements_ConstraintDefinitions_DataElements] ON [cdd].[DataElementConstraintDefinitions] ([DataElementId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[DataElementConstraintDefinitions] ADD CONSTRAINT [FK_DataElements_ConstraintDefinitions_ConstraintDefinitions] FOREIGN KEY ([ConstraintDefinitionId]) REFERENCES [dd].[ConstraintDefinitions] ([ConstraintDefinitionId])
GO
ALTER TABLE [cdd].[DataElementConstraintDefinitions] ADD CONSTRAINT [FK_DataElements_ConstraintDefinitions_DataElements] FOREIGN KEY ([DataElementId]) REFERENCES [cdd].[DataElements] ([DataElementId])
GO
