CREATE TABLE [dbo].[ProjectEDWDefaultMappings]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectEDWDefaultMappings_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectEDWDefaultMappings_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectEDWDefaultMappings] ADD CONSTRAINT [ProjectEDWDefaultMappings_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectEDWDefaultMappings] ADD CONSTRAINT [FK_ProjectEDWDefaultMappings_ProjectId] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectEDWDefaultMappings] ADD CONSTRAINT [FK_ProjectEDWDefaultMappings_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [edw].[EDWDefaultMappings] ([EDWDefaultMappingId])
GO
