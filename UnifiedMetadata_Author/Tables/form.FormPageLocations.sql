CREATE TABLE [form].[FormPageLocations]
(
[FormPageLocationId] [int] NOT NULL IDENTITY(1, 1),
[FormPageLocationName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FormPageLocationValue] [int] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_FormPageLocations_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_FormPageLocations_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [form].[FormPageLocations] ADD CONSTRAINT [PK_FormPageLocations] PRIMARY KEY CLUSTERED  ([FormPageLocationId]) ON [PRIMARY]
GO
