CREATE TABLE [ld].[DeviceManufacturers]
(
[DeviceManufacturerId] [int] NOT NULL IDENTITY(1, 1),
[DeviceManufacturerName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DeviceManufacturers_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DeviceManufacturers_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [ld].[DeviceManufacturers] ADD CONSTRAINT [PK_DeviceManufacturers] PRIMARY KEY CLUSTERED  ([DeviceManufacturerId]) ON [PRIMARY]
GO
