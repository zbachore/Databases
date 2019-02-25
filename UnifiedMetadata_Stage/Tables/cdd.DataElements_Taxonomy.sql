CREATE TABLE [cdd].[DataElements_Taxonomy]
(
[DataElementId] [int] NOT NULL,
[TaxonId] [int] NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DataElements_Taxonomy_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DataElements_Taxonomy_UpdatedDate] DEFAULT (sysdatetime()),
[DataElementTaxonomyId] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[DataElements_Taxonomy] ADD CONSTRAINT [PK_DataElementsTaxonomy] PRIMARY KEY CLUSTERED  ([DataElementTaxonomyId]) ON [PRIMARY]
GO
