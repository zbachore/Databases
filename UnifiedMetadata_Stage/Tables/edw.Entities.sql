CREATE TABLE [edw].[Entities]
(
[EntityId] [int] NOT NULL,
[SchemaName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntityName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntityDescription] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Entities_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Entities_UpdatedDate] DEFAULT (sysdatetime()),
[WorkflowConceptId] [int] NULL,
[DomainConceptId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [edw].[Entities] ADD CONSTRAINT [PK_Entities] PRIMARY KEY CLUSTERED  ([EntityId]) ON [PRIMARY]
GO
