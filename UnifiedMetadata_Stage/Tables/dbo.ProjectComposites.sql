CREATE TABLE [dbo].[ProjectComposites]
(
[Id] [int] NOT NULL,
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectComposites_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectComposites_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectComposites] ADD CONSTRAINT [ProjectComposites_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
