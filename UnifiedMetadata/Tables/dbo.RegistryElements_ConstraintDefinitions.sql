CREATE TABLE [dbo].[RegistryElements_ConstraintDefinitions]
(
[RegistryElementsConstraintDefinitionsID] [int] NOT NULL,
[RegistryElementId] [int] NOT NULL,
[ConstraintDefinitionId] [int] NOT NULL,
[CreatedDate] [datetime2] NOT NULL,
[UpdatedDate] [datetime2] NOT NULL
) ON [PRIMARY]
GO
