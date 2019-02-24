CREATE TABLE [form].[FormSectionConstraintDefintitions]
(
[FormSectionConstraintDefintitionsID] [int] NOT NULL,
[FormSectionId] [int] NOT NULL,
[ConstraintDefinitionId] [int] NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_FormSectionConstraintDefintitions_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_FormSectionConstraintDefintitions_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [form].[FormSectionConstraintDefintitions] ADD CONSTRAINT [PK_FormSectionConstraintDefintitions] PRIMARY KEY CLUSTERED  ([FormSectionConstraintDefintitionsID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_FormSectionConstraintDefintitions_ConstraintDefinitions] ON [form].[FormSectionConstraintDefintitions] ([ConstraintDefinitionId]) ON [PRIMARY]
GO
ALTER TABLE [form].[FormSectionConstraintDefintitions] ADD CONSTRAINT [U_FormSectionConstraintDefintitions] UNIQUE NONCLUSTERED  ([ConstraintDefinitionId], [FormSectionId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_FormSectionConstraintDefintitions_FormSections] ON [form].[FormSectionConstraintDefintitions] ([FormSectionId]) ON [PRIMARY]
GO
