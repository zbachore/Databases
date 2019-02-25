CREATE TABLE [edw].[Population]
(
[PopulationKey] [int] NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Population_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Population_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [edw].[Population] ADD CONSTRAINT [PK_Population] PRIMARY KEY CLUSTERED  ([PopulationKey]) ON [PRIMARY]
GO
