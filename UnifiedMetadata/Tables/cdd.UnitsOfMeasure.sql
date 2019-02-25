CREATE TABLE [cdd].[UnitsOfMeasure]
(
[UnitOfMeasureId] [int] NOT NULL,
[UnitOfMeasureName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UnitOfMeasureDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_UnitsOfMeasure_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_UnitsOfMeasure_UpdatedDate] DEFAULT (sysdatetime()),
[ConceptID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [cdd].[UnitsOfMeasure] ADD CONSTRAINT [PK_UnitsOfMeasure] PRIMARY KEY CLUSTERED  ([UnitOfMeasureId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[UnitsOfMeasure] ADD CONSTRAINT [FK_UnitsOfMeasure_Concepts] FOREIGN KEY ([ConceptID]) REFERENCES [cdd].[Concepts] ([ConceptId])
GO
