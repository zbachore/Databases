CREATE TABLE [edw].[AlgorithmVersionDataElement]
(
[AlgorithmVersionDataElementID] [int] NOT NULL IDENTITY(1, 1),
[AlgorithmVersionID] [int] NULL,
[DataElementID] [int] NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NULL,
[UpdatedDate] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [edw].[AlgorithmVersionDataElement] ADD CONSTRAINT [PK_AlgorithmVersionDataElement] PRIMARY KEY CLUSTERED  ([AlgorithmVersionDataElementID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_AlgorithmVersionDataElement_AlgorithmVersion] ON [edw].[AlgorithmVersionDataElement] ([AlgorithmVersionID]) ON [PRIMARY]
GO
ALTER TABLE [edw].[AlgorithmVersionDataElement] ADD CONSTRAINT [UX_AlgorithmVersionDataElement] UNIQUE NONCLUSTERED  ([AlgorithmVersionID], [DataElementID]) ON [PRIMARY]
GO
ALTER TABLE [edw].[AlgorithmVersionDataElement] ADD CONSTRAINT [FK_AlgorithmVersionDataElement_AlgorithmVersion] FOREIGN KEY ([AlgorithmVersionID]) REFERENCES [edw].[AlgorithmVersion] ([AlgorithmVersionID])
GO
