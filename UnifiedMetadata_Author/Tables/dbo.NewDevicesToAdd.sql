CREATE TABLE [dbo].[NewDevicesToAdd]
(
[RegistryVersion] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ValueSetID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeviceId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeviceManufacturerId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeviceTypeId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeviceSubtypeId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeviceName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeviceModelNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EndDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DevicePublishedId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[valueSetMemberLabel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
