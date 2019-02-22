CREATE TABLE [dbo].[ProjectRegistries]
(
[Id] [int] NOT NULL,
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectRegistries_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectRegistries_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectRegistries] ADD CONSTRAINT [ProjectRegistryId_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
