CREATE TABLE [dbo].[ProjectValueSetConceptMembers]
(
[Id] [int] NOT NULL,
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
