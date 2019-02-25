CREATE TABLE [dbo].[ProjectDataElementCodingInstructions]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectDataElementCodingInstructions_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectDataElementCodingInstructions_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectDataElementCodingInstructions] ADD CONSTRAINT [ProjectDataElementCodingInstructions_PK] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectDataElementCodingInstructions] ADD CONSTRAINT [FK_ProjectDataElementCodingInstructions_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectDataElementCodingInstructions] WITH NOCHECK ADD CONSTRAINT [FK_ProjectDataElementCodingInstructions_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [cdd].[DataElementCodingInstructions] ([DataElementCodingInstructionId])
GO
ALTER TABLE [dbo].[ProjectDataElementCodingInstructions] NOCHECK CONSTRAINT [FK_ProjectDataElementCodingInstructions_ReferenceId]
GO
