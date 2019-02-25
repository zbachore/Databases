CREATE TABLE [dbo].[ProjectDataElementValueSets]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectDataElementValueSets_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectDataElementValueSets_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectDataElementValueSets] ADD CONSTRAINT [ProjectDataElementValueSetsId_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectDataElementValueSets] ADD CONSTRAINT [FK_ProjectDataElementValueSets_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectDataElementValueSets] WITH NOCHECK ADD CONSTRAINT [FK_ProjectDataElementValueSets_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [cdd].[DataElements_ValueSets] ([DataElementsValueSetsID])
GO
ALTER TABLE [dbo].[ProjectDataElementValueSets] NOCHECK CONSTRAINT [FK_ProjectDataElementValueSets_ReferenceId]
GO
