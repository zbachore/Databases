CREATE TABLE [form].[FormPageConstraintDefinitions]
(
[FormPageConstraintDefinitionsID] [int] NOT NULL,
[FormPageId] [int] NOT NULL,
[ConstraintDefinitionId] [int] NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_FormPageConstraintDefinitions_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_FormPageConstraintDefinitions_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [form].[FormPageConstraintDefinitions] ADD CONSTRAINT [PK_FormPageConstraintDefinitions] PRIMARY KEY CLUSTERED  ([FormPageConstraintDefinitionsID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_FormPageConstraintDefinitions_ConstraintDefinitions] ON [form].[FormPageConstraintDefinitions] ([ConstraintDefinitionId]) ON [PRIMARY]
GO
ALTER TABLE [form].[FormPageConstraintDefinitions] ADD CONSTRAINT [U_FormPageConstraintDefinitions] UNIQUE NONCLUSTERED  ([ConstraintDefinitionId], [FormPageId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_FormPageConstraintDefinitions_FormPages] ON [form].[FormPageConstraintDefinitions] ([FormPageId]) ON [PRIMARY]
GO
ALTER TABLE [form].[FormPageConstraintDefinitions] ADD CONSTRAINT [FK_FormPageConstraintDefinitions_ConstraintDefinitions] FOREIGN KEY ([ConstraintDefinitionId]) REFERENCES [dd].[ConstraintDefinitions] ([ConstraintDefinitionId])
GO
ALTER TABLE [form].[FormPageConstraintDefinitions] ADD CONSTRAINT [FK_FormPageConstraintDefinitions_FormPages] FOREIGN KEY ([FormPageId]) REFERENCES [form].[FormPages] ([FormPageId])
GO
