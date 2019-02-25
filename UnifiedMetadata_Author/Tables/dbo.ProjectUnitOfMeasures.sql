CREATE TABLE [dbo].[ProjectUnitOfMeasures]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectUnitOfMeasures_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectUnitOfMeasures_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectUnitOfMeasures] ADD CONSTRAINT [ProjectUnitOfMeasures_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectUnitOfMeasures] ADD CONSTRAINT [FK_ProjectUnitOfMeasures_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectUnitOfMeasures] WITH NOCHECK ADD CONSTRAINT [FK_ProjectUnitOfMeasures_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [cdd].[UnitsOfMeasure] ([UnitOfMeasureId])
GO
ALTER TABLE [dbo].[ProjectUnitOfMeasures] NOCHECK CONSTRAINT [FK_ProjectUnitOfMeasures_ReferenceId]
GO
