CREATE TABLE [dbo].[ProjectDataTypesConstraintTypes]
(
[Id] [int] NOT NULL,
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