CREATE TABLE [cdd].[DataTypes_ConstraintTypes]
(
[DataTypesConstraintTypesID] [int] NOT NULL,
[DataTypeId] [int] NOT NULL,
[ConstraintTypeId] [int] NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DataTypes_ConstraintTypes_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DataTypes_ConstraintTypes_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[DataTypes_ConstraintTypes] ADD CONSTRAINT [PK_DataType_ConstraintType] PRIMARY KEY CLUSTERED  ([DataTypesConstraintTypesID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_DataType_ConstraintType_ConstraintType] ON [cdd].[DataTypes_ConstraintTypes] ([ConstraintTypeId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[DataTypes_ConstraintTypes] ADD CONSTRAINT [U_DataTypes_ConstraintTypes] UNIQUE NONCLUSTERED  ([ConstraintTypeId], [DataTypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_DataType_ConstraintType_DataType] ON [cdd].[DataTypes_ConstraintTypes] ([DataTypeId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[DataTypes_ConstraintTypes] ADD CONSTRAINT [FK_DataType_ConstraintType_ConstraintType] FOREIGN KEY ([ConstraintTypeId]) REFERENCES [dd].[ConstraintTypes] ([ConstraintTypeId])
GO
ALTER TABLE [cdd].[DataTypes_ConstraintTypes] ADD CONSTRAINT [FK_DataType_ConstraintType_DataType] FOREIGN KEY ([DataTypeId]) REFERENCES [cdd].[DataTypes] ([DataTypeId])
GO
