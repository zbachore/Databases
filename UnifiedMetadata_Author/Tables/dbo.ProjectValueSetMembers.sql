CREATE TABLE [dbo].[ProjectValueSetMembers]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__ProjectValueSetMemberss_CreateDate] DEFAULT (getdate()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectValueSetMembers] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectValueSetMembers] ADD CONSTRAINT [PK_ProjectValueSetMembers] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectValueSetMembers] ADD CONSTRAINT [FK_ProjectValueSetMembers_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectValueSetMembers] WITH NOCHECK ADD CONSTRAINT [FK_ProjectValueSetMembers_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [cdd].[ValueSetMembers] ([ValueSetMemberId])
GO
ALTER TABLE [dbo].[ProjectValueSetMembers] NOCHECK CONSTRAINT [FK_ProjectValueSetMembers_ReferenceId]
GO
