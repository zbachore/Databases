CREATE TABLE [dbo].[ProjectValueSets]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
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
ALTER TABLE [dbo].[ProjectValueSets] ADD CONSTRAINT [FK_ProjectValueSets_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectValueSets] WITH NOCHECK ADD CONSTRAINT [FK_ProjectValueSets_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [cdd].[ValueSets] ([ValueSetId])
GO
ALTER TABLE [dbo].[ProjectValueSets] NOCHECK CONSTRAINT [FK_ProjectValueSets_ReferenceId]
GO
