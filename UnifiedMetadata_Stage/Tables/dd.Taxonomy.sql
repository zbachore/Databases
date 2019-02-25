CREATE TABLE [dd].[Taxonomy]
(
[TaxonId] [int] NOT NULL,
[ParentTaxonId] [int] NULL,
[TaxonName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TaxonDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Taxonomy_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Taxonomy_UpdatedDate] DEFAULT (sysdatetime()),
[DisplayOrder] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dd].[Taxonomy] ADD CONSTRAINT [PK_Taxonomy] PRIMARY KEY CLUSTERED  ([TaxonId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_Taxonomy_Taxonomy] ON [dd].[Taxonomy] ([TaxonId]) ON [PRIMARY]
GO
