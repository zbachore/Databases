CREATE TABLE [dbo].[ProjectConcepts]
(
[Id] [int] NOT NULL,
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectConcepts_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectConcepts_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectConcepts] ADD CONSTRAINT [ProjectConceptId_PK] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ProjectConcepts_ProjectID_ReferenceID] ON [dbo].[ProjectConcepts] ([ProjectId], [ReferenceId]) ON [PRIMARY]
GO
