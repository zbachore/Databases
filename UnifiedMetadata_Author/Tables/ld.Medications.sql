CREATE TABLE [ld].[Medications]
(
[MedicationId] [int] NOT NULL IDENTITY(1, 1),
[ConceptId] [int] NOT NULL,
[MedicationCategoryId] [int] NULL,
[MedicationSubCategoryId] [int] NULL,
[StartDate] [datetime2] NULL,
[EndDate] [datetime2] NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Medications_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Medications_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [ld].[Medications] ADD CONSTRAINT [PK_Medications] PRIMARY KEY CLUSTERED  ([MedicationId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_Medications_Concepts] ON [ld].[Medications] ([ConceptId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_Medications_MedicationCategories] ON [ld].[Medications] ([MedicationCategoryId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_Medications_MedicationCategories_02] ON [ld].[Medications] ([MedicationSubCategoryId]) ON [PRIMARY]
GO
ALTER TABLE [ld].[Medications] ADD CONSTRAINT [FK_Medications_Concepts] FOREIGN KEY ([ConceptId]) REFERENCES [cdd].[Concepts] ([ConceptId])
GO
ALTER TABLE [ld].[Medications] ADD CONSTRAINT [FK_Medications_MedicationCategories] FOREIGN KEY ([MedicationCategoryId]) REFERENCES [ld].[MedicationCategories] ([MedicationCategoryId])
GO
ALTER TABLE [ld].[Medications] ADD CONSTRAINT [FK_Medications_MedicationCategories_02] FOREIGN KEY ([MedicationSubCategoryId]) REFERENCES [ld].[MedicationCategories] ([MedicationCategoryId])
GO
