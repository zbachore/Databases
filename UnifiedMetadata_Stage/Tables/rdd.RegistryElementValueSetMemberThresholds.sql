CREATE TABLE [rdd].[RegistryElementValueSetMemberThresholds]
(
[RegistryElementValueSetMemberThresholdId] [int] NOT NULL IDENTITY(1, 1),
[RegistryElementId] [int] NOT NULL,
[ValueSetMemberId] [int] NOT NULL,
[Threshold] [int] NOT NULL,
[CompositeId] [int] NOT NULL,
[UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryElementValueSetMemberThresholds_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryElementValueSetMemberThresholds_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryElementValueSetMemberThresholds] ADD CONSTRAINT [PK_RegistryElementValueSetMemberThresholds] PRIMARY KEY CLUSTERED  ([RegistryElementValueSetMemberThresholdId]) ON [PRIMARY]
GO
