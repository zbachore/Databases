CREATE TABLE [ld].[DeviceSubtypes]
(
[DeviceSubtypeId] [int] NOT NULL,
[DeviceTypeId] [int] NOT NULL,
[DeviceSubtypeName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DeviceSubtypes_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DeviceSubtypes_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [ld].[DeviceSubtypes] ADD CONSTRAINT [PK_DeviceSubtypes] PRIMARY KEY CLUSTERED  ([DeviceSubtypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_DeviceSubtypes_DeviceTypes] ON [ld].[DeviceSubtypes] ([DeviceTypeId]) ON [PRIMARY]
GO
