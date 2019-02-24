CREATE TABLE [cdd].[ValueSetDeviceMembers]
(
[ValueSetMemberId] [int] NOT NULL,
[DeviceId] [int] NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ValueSetDeviceMembers_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ValueSetDeviceMembers_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[ValueSetDeviceMembers] ADD CONSTRAINT [PK_ValueSetDeviceMembers] PRIMARY KEY CLUSTERED  ([ValueSetMemberId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ValueSetDeviceMembers_Devices] ON [cdd].[ValueSetDeviceMembers] ([DeviceId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ValueSetDeviceMembers_ValueSetMembers] ON [cdd].[ValueSetDeviceMembers] ([ValueSetMemberId]) ON [PRIMARY]
GO
