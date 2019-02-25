CREATE TABLE [dbo].[ProjectMedicationCategories]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectMedicationCategories_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectMedicationCategories_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectMedicationCategories] ADD CONSTRAINT [ProjectMedicationCategories_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectMedicationCategories] ADD CONSTRAINT [FK_ProjectMedicationCategories_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectMedicationCategories] WITH NOCHECK ADD CONSTRAINT [FK_ProjectMedicationCategories_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [ld].[MedicationCategories] ([MedicationCategoryId])
GO
ALTER TABLE [dbo].[ProjectMedicationCategories] NOCHECK CONSTRAINT [FK_ProjectMedicationCategories_ReferenceId]
GO
