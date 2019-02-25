CREATE TABLE [dbo].[ProjectDataTypesConstraintTypes]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectDataTypesConstraintTypes_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectDataTypesConstraintTypes_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectDataTypesConstraintTypes] ADD CONSTRAINT [ProjectDataTypesConstraintTypes_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectDataTypesConstraintTypes] ADD CONSTRAINT [FK_ProjectDataTypesConstraintTypes_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectDataTypesConstraintTypes] WITH NOCHECK ADD CONSTRAINT [FK_ProjectDataTypesConstraintTypes_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [cdd].[DataTypes_ConstraintTypes] ([DataTypesConstraintTypesID])
GO
ALTER TABLE [dbo].[ProjectDataTypesConstraintTypes] NOCHECK CONSTRAINT [FK_ProjectDataTypesConstraintTypes_ReferenceId]
GO
