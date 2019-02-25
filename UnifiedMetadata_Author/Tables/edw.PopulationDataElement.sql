CREATE TABLE [edw].[PopulationDataElement]
(
[PopulationDataElementID] [int] NOT NULL IDENTITY(1, 1),
[PopulationKey] [int] NULL,
[DataElementID] [int] NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NULL,
[UpdatedDate] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [edw].[PopulationDataElement] ADD CONSTRAINT [PK_PopulationDataElement] PRIMARY KEY CLUSTERED  ([PopulationDataElementID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_PopulationDataElement_Population] ON [edw].[PopulationDataElement] ([PopulationKey]) ON [PRIMARY]
GO
ALTER TABLE [edw].[PopulationDataElement] ADD CONSTRAINT [UX_PopulationDataElement] UNIQUE NONCLUSTERED  ([PopulationKey], [DataElementID]) ON [PRIMARY]
GO
ALTER TABLE [edw].[PopulationDataElement] ADD CONSTRAINT [FK_PopulationDataElement_Population] FOREIGN KEY ([PopulationKey]) REFERENCES [edw].[Population] ([PopulationKey])
GO
