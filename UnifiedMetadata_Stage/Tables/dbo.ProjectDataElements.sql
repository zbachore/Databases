CREATE TABLE [dbo].[ProjectDataElements]
(
[Id] [int] NOT NULL,
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectDataElements_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectDataElements_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectDataElements] ADD CONSTRAINT [ProjectDataElements_PK] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ProjectDataElements_ProjectID_ReferenceID] ON [dbo].[ProjectDataElements] ([ProjectId], [ReferenceId]) ON [PRIMARY]
GO
