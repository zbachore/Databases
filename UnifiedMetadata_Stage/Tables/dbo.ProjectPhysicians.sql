CREATE TABLE [dbo].[ProjectPhysicians]
(
[Id] [int] NOT NULL,
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectPhysicians_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectPhysicians_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectPhysicians] ADD CONSTRAINT [ProjectPhysicianId_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
