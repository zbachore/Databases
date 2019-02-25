CREATE TABLE [dbo].[ProjectDevices]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectDevices_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectDevices_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectDevices] ADD CONSTRAINT [ProjectDevices_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectDevices] ADD CONSTRAINT [FK_ProjectDevices_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectDevices] WITH NOCHECK ADD CONSTRAINT [FK_ProjectDevices_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [ld].[Devices] ([DeviceId])
GO
ALTER TABLE [dbo].[ProjectDevices] NOCHECK CONSTRAINT [FK_ProjectDevices_ReferenceId]
GO
