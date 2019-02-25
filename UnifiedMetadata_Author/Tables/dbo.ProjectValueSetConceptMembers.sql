CREATE TABLE [dbo].[ProjectValueSetConceptMembers]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectValueSetConceptMembers_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectValueSetConceptMembers_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectValueSetConceptMembers] ADD CONSTRAINT [ProjectValueSetConceptMembers_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectValueSetConceptMembers] ADD CONSTRAINT [FK_ProjectValueSetConceptMembers_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectValueSetConceptMembers] WITH NOCHECK ADD CONSTRAINT [FK_ProjectValueSetConceptMembers_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [cdd].[ValueSetConceptMembers] ([ValueSetMemberId])
GO
ALTER TABLE [dbo].[ProjectValueSetConceptMembers] NOCHECK CONSTRAINT [FK_ProjectValueSetConceptMembers_ReferenceId]
GO
