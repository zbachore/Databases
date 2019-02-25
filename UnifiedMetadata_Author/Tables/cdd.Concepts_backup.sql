CREATE TABLE [cdd].[Concepts_backup]
(
[ConceptId] [int] NOT NULL IDENTITY(1, 1),
[CodeSystemTermId] [int] NULL,
[ConceptName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DomainConceptId] [int] NULL,
[IsActive] [bit] NOT NULL,
[StartDate] [datetime2] NULL,
[EndDate] [datetime2] NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Concepts_backup_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Concepts_backup_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
