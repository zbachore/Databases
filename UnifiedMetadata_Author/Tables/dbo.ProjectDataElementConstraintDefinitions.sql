CREATE TABLE [dbo].[ProjectDataElementConstraintDefinitions]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectDataElementConstraintDefinitions_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectDataElementConstraintDefinitions_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectDataElementConstraintDefinitions] ADD CONSTRAINT [ProjectDataElementConstraintDefinitionsId_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectDataElementConstraintDefinitions] ADD CONSTRAINT [FK_ProjectDataElementConstraintDefinitions_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectDataElementConstraintDefinitions] WITH NOCHECK ADD CONSTRAINT [FK_ProjectDataElementConstraintDefinitions_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [cdd].[DataElementConstraintDefinitions] ([DataElementConstraintDefinitionsID])
GO
ALTER TABLE [dbo].[ProjectDataElementConstraintDefinitions] NOCHECK CONSTRAINT [FK_ProjectDataElementConstraintDefinitions_ReferenceId]
GO
