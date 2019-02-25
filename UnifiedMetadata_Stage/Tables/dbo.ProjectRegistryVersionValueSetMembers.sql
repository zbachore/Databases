CREATE TABLE [dbo].[ProjectRegistryVersionValueSetMembers]
(
[Id] [int] NOT NULL,
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ProjectRegistryVersionValueSetMembers_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ProjectRegistryVersionValueSetMembers_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectRegistryVersionValueSetMembers] ADD CONSTRAINT [ProjectRegistryVersionValueSetMembers_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
