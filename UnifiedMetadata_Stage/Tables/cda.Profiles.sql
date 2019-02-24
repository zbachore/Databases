CREATE TABLE [cda].[Profiles]
(
[ProfileId] [int] NOT NULL,
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
