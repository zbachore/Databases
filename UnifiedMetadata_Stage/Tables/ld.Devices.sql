CREATE TABLE [ld].[Devices]
(
[DeviceId] [int] NOT NULL,
[DeviceManufacturerId] [int] NOT NULL,
[DeviceTypeId] [int] NOT NULL,
[DeviceSubtypeId] [int] NULL,
[DeviceName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DeviceModelNumber] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartDate] [datetime2] NULL,
[EndDate] [datetime2] NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Devices_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Devices_UpdatedDate] DEFAULT (sysdatetime()),
[DevicePublishedId] [int] NOT NULL
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
