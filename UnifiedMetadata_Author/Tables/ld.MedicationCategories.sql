CREATE TABLE [ld].[MedicationCategories]
(
[MedicationCategoryId] [int] NOT NULL IDENTITY(1, 1),
[MedicationCategoryName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_MedicationCategories_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_MedicationCategories_UpdatedDate] DEFAULT (sysdatetime()),
[DisplayOrder] [int] NOT NULL CONSTRAINT [DF_MedicationCategories_DisplayOrder] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [ld].[MedicationCategories] ADD CONSTRAINT [PK_MedicationCategories] PRIMARY KEY CLUSTERED  ([MedicationCategoryId]) ON [PRIMARY]
GO
