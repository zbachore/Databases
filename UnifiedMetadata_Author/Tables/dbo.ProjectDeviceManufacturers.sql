CREATE TABLE [dbo].[ProjectDeviceManufacturers]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectDeviceManufacturers_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectDeviceManufacturers_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectDeviceManufacturers] ADD CONSTRAINT [ProjectDeviceManufacturers_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectDeviceManufacturers] ADD CONSTRAINT [FK_ProjectDeviceManufacturers_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectDeviceManufacturers] WITH NOCHECK ADD CONSTRAINT [FK_ProjectDeviceManufacturers_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [ld].[DeviceManufacturers] ([DeviceManufacturerId])
GO
ALTER TABLE [dbo].[ProjectDeviceManufacturers] NOCHECK CONSTRAINT [FK_ProjectDeviceManufacturers_ReferenceId]
GO
