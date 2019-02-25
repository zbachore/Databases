CREATE TABLE [cdd].[ValueSetUnitOfMeasureMembers]
(
[ValueSetMemberId] [int] NOT NULL,
[UnitOfMeasureId] [int] NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ValueSetUnitOfMeasureMembers_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ValueSetUnitOfMeasureMembers_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[ValueSetUnitOfMeasureMembers] ADD CONSTRAINT [PK_ValueSetUnitOfMeasureMembers] PRIMARY KEY CLUSTERED  ([ValueSetMemberId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ValueSets_UnitsOfMeasure_UnitsOfMeasure] ON [cdd].[ValueSetUnitOfMeasureMembers] ([UnitOfMeasureId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ValueSetUnitOfMeasureMembers_ValueSetMembers] ON [cdd].[ValueSetUnitOfMeasureMembers] ([ValueSetMemberId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[ValueSetUnitOfMeasureMembers] ADD CONSTRAINT [FK_ValueSets_UnitsOfMeasure_UnitsOfMeasure] FOREIGN KEY ([UnitOfMeasureId]) REFERENCES [cdd].[UnitsOfMeasure] ([UnitOfMeasureId])
GO
ALTER TABLE [cdd].[ValueSetUnitOfMeasureMembers] ADD CONSTRAINT [FK_ValueSetUnitOfMeasureMembers_ValueSetMembers] FOREIGN KEY ([ValueSetMemberId]) REFERENCES [cdd].[ValueSetMembers] ([ValueSetMemberId])
GO
