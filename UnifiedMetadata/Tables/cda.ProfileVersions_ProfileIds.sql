CREATE TABLE [cda].[ProfileVersions_ProfileIds]
(
[ProfileVersionsProfileIdsID] [int] NOT NULL,
[ProfileVersionId] [int] NOT NULL,
[ProfileIdId] [int] NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ProfileVersions_ProfileIds_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ProfileVersions_ProfileIds_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cda].[ProfileVersions_ProfileIds] ADD CONSTRAINT [PK_ProfileVersions_ProfileIds] PRIMARY KEY CLUSTERED  ([ProfileVersionsProfileIdsID]) ON [PRIMARY]
GO
ALTER TABLE [cda].[ProfileVersions_ProfileIds] ADD CONSTRAINT [U_ProfileVersions_ProfileIds] UNIQUE NONCLUSTERED  ([ProfileIdId], [ProfileVersionId]) ON [PRIMARY]
GO
ALTER TABLE [cda].[ProfileVersions_ProfileIds] ADD CONSTRAINT [FK__ProfileVe__Profi__6D823440] FOREIGN KEY ([ProfileVersionId]) REFERENCES [cda].[ProfileVersions] ([ProfileVersionId])
GO
ALTER TABLE [cda].[ProfileVersions_ProfileIds] ADD CONSTRAINT [FK__ProfileVe__Profi__75E27017] FOREIGN KEY ([ProfileIdId]) REFERENCES [cda].[ProfileIds] ([ProfileIdId])
GO
