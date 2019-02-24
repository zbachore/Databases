CREATE TABLE [ld].[DeviceTypes]
(
[DeviceTypeId] [int] NOT NULL,
[DeviceTypeName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DeviceTypes_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DeviceTypes_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [ld].[DeviceTypes] ADD CONSTRAINT [PK_DeviceTypes] PRIMARY KEY CLUSTERED  ([DeviceTypeId]) ON [PRIMARY]
GO
