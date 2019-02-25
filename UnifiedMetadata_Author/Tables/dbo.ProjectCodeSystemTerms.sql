CREATE TABLE [dbo].[ProjectCodeSystemTerms]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectCodeSystemTerms_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectCodeSystemTerms_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectCodeSystemTerms] ADD CONSTRAINT [ProjectCodeSystemTermsId_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectCodeSystemTerms] ADD CONSTRAINT [FK_ProjectCodeSystemTerms_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectCodeSystemTerms] WITH NOCHECK ADD CONSTRAINT [FK_ProjectCodeSystemTerms_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [cdd].[CodeSystemTerms] ([CodeSystemTermId])
GO
ALTER TABLE [dbo].[ProjectCodeSystemTerms] NOCHECK CONSTRAINT [FK_ProjectCodeSystemTerms_ReferenceId]
GO
