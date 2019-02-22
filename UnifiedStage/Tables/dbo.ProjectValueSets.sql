CREATE TABLE [dbo].[ProjectValueSets]
(
[Id] [int] NOT NULL,
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__ProjectValueSets_CreateDate] DEFAULT (getdate()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectValueSets] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectValueSets] ADD CONSTRAINT [ProjectValueSets_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ProjectValueSets_ProjectID_ReferenceID] ON [dbo].[ProjectValueSets] ([ProjectId], [ReferenceId]) ON [PRIMARY]
GO
