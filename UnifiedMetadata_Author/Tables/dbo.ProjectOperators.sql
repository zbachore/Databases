CREATE TABLE [dbo].[ProjectOperators]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL,
[UpdatedDate] [datetime2] NULL,
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectOperators] ADD CONSTRAINT [ProjectOperatorsId_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectOperators] WITH NOCHECK ADD CONSTRAINT [FK_ProjectOperators_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [ld].[Operators] ([OperatorId])
GO
ALTER TABLE [dbo].[ProjectOperators] NOCHECK CONSTRAINT [FK_ProjectOperators_ReferenceId]
GO
