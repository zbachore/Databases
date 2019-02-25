CREATE TABLE [cda].[Profiles]
(
[ProfileId] [int] NOT NULL IDENTITY(1, 1),
[ProfileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProfileDescription] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[StartDate] [datetime2] NULL,
[EndDate] [datetime2] NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Profiles_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Profiles_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cda].[Profiles] ADD CONSTRAINT [PK_Profiles] PRIMARY KEY NONCLUSTERED  ([ProfileId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains all the Implementation Guides released by ACC. Although a implementation guide is generally released through IHE it might not always be the case, so this table might contain other IGs that are not published through IHE. ', 'SCHEMA', N'cda', 'TABLE', N'Profiles', NULL, NULL
GO
