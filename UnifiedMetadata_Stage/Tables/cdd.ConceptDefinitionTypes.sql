CREATE TABLE [cdd].[ConceptDefinitionTypes]
(
[ConceptDefinitionTypeId] [int] NOT NULL,
[ConceptDefinitionType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConceptDefinitionDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ConceptDefinitionTypes_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ConceptDefinitionTypes_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [cdd].[ConceptDefinitionTypes] ADD CONSTRAINT [PK_ConceptDefinitionType] PRIMARY KEY CLUSTERED  ([ConceptDefinitionTypeId]) ON [PRIMARY]
GO
