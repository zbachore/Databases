CREATE TABLE [edw].[EntityColumns]
(
[EntityColumnId] [int] NOT NULL,
[EntityId] [int] NULL,
[EntityColumnName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntityColumnDescription] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_EntityColumns_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_EntityColumns_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [edw].[EntityColumns] ADD CONSTRAINT [PK_EntityColumns] PRIMARY KEY CLUSTERED  ([EntityColumnId]) ON [PRIMARY]
GO
ALTER TABLE [edw].[EntityColumns] ADD CONSTRAINT [FK_EntityColumns_EntityId] FOREIGN KEY ([EntityId]) REFERENCES [edw].[Entities] ([EntityId])
GO
