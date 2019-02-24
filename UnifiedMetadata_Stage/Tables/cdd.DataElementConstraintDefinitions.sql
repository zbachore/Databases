CREATE TABLE [cdd].[DataElementConstraintDefinitions]
(
[DataElementConstraintDefinitionsID] [int] NOT NULL,
[DataElementId] [int] NOT NULL,
[ConstraintDefinitionId] [int] NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DataElementConstraintDefinitions_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DataElementConstraintDefinitions_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[DataElementConstraintDefinitions] ADD CONSTRAINT [PK_DataElementId_ConstraintDefinitionId] PRIMARY KEY CLUSTERED  ([DataElementConstraintDefinitionsID]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[DataElementConstraintDefinitions] ADD CONSTRAINT [U_DataElements_ConstraintDefinitions_ConstraintDefinitionId] UNIQUE NONCLUSTERED  ([ConstraintDefinitionId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[DataElementConstraintDefinitions] ADD CONSTRAINT [U_DataElementConstraintDefinitions] UNIQUE NONCLUSTERED  ([ConstraintDefinitionId], [DataElementId]) ON [PRIMARY]
GO
