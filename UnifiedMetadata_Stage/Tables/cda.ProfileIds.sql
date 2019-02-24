CREATE TABLE [cda].[ProfileIds]
(
[ProfileIdId] [int] NOT NULL,
[ProfileIdRoot] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProfileIdExtension] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ProfileIds_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ProfileIds_UpdatedDate] DEFAULT (sysdatetime()),
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [cda].[ProfileIds] ADD CONSTRAINT [PK__ProfileI__A9D5C2F366A02C87] PRIMARY KEY CLUSTERED  ([ProfileIdId]) ON [PRIMARY]
GO
ALTER TABLE [cda].[ProfileIds] ADD CONSTRAINT [UC_RootExtension] UNIQUE NONCLUSTERED  ([ProfileIdRoot], [ProfileIdExtension]) ON [PRIMARY]
GO
