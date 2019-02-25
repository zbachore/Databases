CREATE TABLE [cdd].[UnitsOfMeasureAlias]
(
[UnitOfMeasureAliasId] [int] NOT NULL IDENTITY(1, 1),
[UnitOfMeasureId] [int] NULL,
[UnitOfMeasureAliasName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_UnitsOfMeasureAlias_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_UnitsOfMeasureAlias_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[UnitsOfMeasureAlias] ADD CONSTRAINT [PK_UnitsOfMeasureAlias] PRIMARY KEY CLUSTERED  ([UnitOfMeasureAliasId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[UnitsOfMeasureAlias] ADD CONSTRAINT [FK_UnitsOfMeasureId] FOREIGN KEY ([UnitOfMeasureId]) REFERENCES [cdd].[UnitsOfMeasure] ([UnitOfMeasureId])
GO
