CREATE TABLE [cdd].[ConceptDefinitions]
(
[ConceptDefinitionId] [int] NOT NULL,
[ConceptId] [int] NOT NULL,
[ConceptDefinitionTypeId] [int] NOT NULL,
[ConceptDefinitionName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConceptDefinitionDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConceptDefinitionSource] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartDate] [datetime2] NULL,
[EndDate] [datetime2] NULL,
[IsActive] [bit] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ConceptDefinitions_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ConceptDefinitions_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [cdd].[ConceptDefinitions] ADD CONSTRAINT [PK_ConceptDefinition] PRIMARY KEY NONCLUSTERED  ([ConceptDefinitionId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ConceptDefinition_ConceptDefinitionType] ON [cdd].[ConceptDefinitions] ([ConceptDefinitionTypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ConceptDefinition_Concept] ON [cdd].[ConceptDefinitions] ([ConceptId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[ConceptDefinitions] ADD CONSTRAINT [FK_ConceptDefinition_Concept] FOREIGN KEY ([ConceptId]) REFERENCES [cdd].[Concepts] ([ConceptId])
GO
ALTER TABLE [cdd].[ConceptDefinitions] ADD CONSTRAINT [FK_ConceptDefinition_ConceptDefinitionType] FOREIGN KEY ([ConceptDefinitionTypeId]) REFERENCES [cdd].[ConceptDefinitionTypes] ([ConceptDefinitionTypeId])
GO
