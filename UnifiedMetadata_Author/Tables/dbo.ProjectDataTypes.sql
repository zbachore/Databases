CREATE TABLE [dbo].[ProjectDataTypes]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectDataTypes_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectDataTypes_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectDataTypes] ADD CONSTRAINT [ProjectDataTypes_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectDataTypes] ADD CONSTRAINT [FK_ProjectDataTypes_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectDataTypes] WITH NOCHECK ADD CONSTRAINT [FK_ProjectDataTypes_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [cdd].[DataTypes] ([DataTypeId])
GO
ALTER TABLE [dbo].[ProjectDataTypes] NOCHECK CONSTRAINT [FK_ProjectDataTypes_ReferenceId]
GO
