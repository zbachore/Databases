CREATE TABLE [cdd].[ConceptSynonyms]
(
[ConceptSynonymId] [int] NOT NULL,
[ConceptId] [int] NOT NULL,
[Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ConceptSynonyms_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ConceptSynonyms_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[ConceptSynonyms] ADD CONSTRAINT [PK_ConceptSynonym] PRIMARY KEY CLUSTERED  ([ConceptSynonymId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ConceptSynonym_Concept] ON [cdd].[ConceptSynonyms] ([ConceptId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[ConceptSynonyms] ADD CONSTRAINT [FK_ConceptSynonym_Concept] FOREIGN KEY ([ConceptId]) REFERENCES [cdd].[Concepts] ([ConceptId])
GO
