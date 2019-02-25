CREATE TABLE [dbo].[ProjectAlgorithmVersionDataElement]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectAlgorithmVersionDataElement_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectAlgorithmVersionDataElement_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectAlgorithmVersionDataElement] ADD CONSTRAINT [ProjectAlgorithmVersionDataElement_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectAlgorithmVersionDataElement] ADD CONSTRAINT [FK_ProjectAlgorithmVersionDataElement_ProjectId] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectAlgorithmVersionDataElement] ADD CONSTRAINT [FK_ProjectAlgorithmVersionDataElement_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [edw].[AlgorithmVersionDataElement] ([AlgorithmVersionDataElementID])
GO
