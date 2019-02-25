CREATE TABLE [ld].[Devices]
(
[DeviceId] [int] NOT NULL IDENTITY(1, 1),
[DeviceManufacturerId] [int] NOT NULL,
[DeviceTypeId] [int] NOT NULL,
[DeviceSubtypeId] [int] NULL,
[DeviceName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DeviceModelNumber] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartDate] [datetime] NOT NULL CONSTRAINT [DF_Devices_StartDate] DEFAULT ('01/01/1900'),
[EndDate] [datetime] NOT NULL CONSTRAINT [DF_Devices_EndDate] DEFAULT ('12/31/9999'),
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Devices_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Devices_UpdatedDate] DEFAULT (sysdatetime()),
[DevicePublishedId] [int] NOT NULL CONSTRAINT [DF_Devices_DevicePublishedId] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [ld].[Devices] ADD CONSTRAINT [PK_Devices] PRIMARY KEY CLUSTERED  ([DeviceId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_Devices_DeviceManufacturers] ON [ld].[Devices] ([DeviceManufacturerId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_Devices_DeviceSubtypes] ON [ld].[Devices] ([DeviceSubtypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_Devices_DeviceTypes] ON [ld].[Devices] ([DeviceTypeId]) ON [PRIMARY]
GO
ALTER TABLE [ld].[Devices] ADD CONSTRAINT [FK_Devices_DeviceManufacturers] FOREIGN KEY ([DeviceManufacturerId]) REFERENCES [ld].[DeviceManufacturers] ([DeviceManufacturerId])
GO
ALTER TABLE [ld].[Devices] ADD CONSTRAINT [FK_Devices_DeviceSubtypes] FOREIGN KEY ([DeviceSubtypeId]) REFERENCES [ld].[DeviceSubtypes] ([DeviceSubtypeId])
GO
ALTER TABLE [ld].[Devices] ADD CONSTRAINT [FK_Devices_DeviceTypes] FOREIGN KEY ([DeviceTypeId]) REFERENCES [ld].[DeviceTypes] ([DeviceTypeId])
GO
