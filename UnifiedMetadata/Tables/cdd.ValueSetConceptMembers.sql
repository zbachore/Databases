CREATE TABLE [cdd].[ValueSetConceptMembers]
(
[ValueSetMemberId] [int] NOT NULL,
[ConceptId] [int] NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ValueSetConceptMembers_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ValueSetConceptMembers_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[ValueSetConceptMembers] ADD CONSTRAINT [PK_ValueSetConceptMembers] PRIMARY KEY CLUSTERED  ([ValueSetMemberId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ValueSetMembers_Concepts] ON [cdd].[ValueSetConceptMembers] ([ConceptId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ValueSetConceptMembers_ValueSetMembers] ON [cdd].[ValueSetConceptMembers] ([ValueSetMemberId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[ValueSetConceptMembers] ADD CONSTRAINT [FK_ValueSetConceptMembers] FOREIGN KEY ([ConceptId]) REFERENCES [cdd].[Concepts] ([ConceptId])
GO
