CREATE TABLE [edw].[EntityColumns_RegistryElements]
(
[EntityColumnsRegistryElementsID] [int] NOT NULL,
[EntityColumnId] [int] NOT NULL,
[RegistryElementId] [int] NOT NULL,
[TimePartEntityColumnId] [int] NULL,
[IsFlipElementValue] [bit] NULL,
[MappingInstruction] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_EntityColumns_RegistryElements_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_EntityColumns_RegistryElements_UpdatedDate] DEFAULT (sysdatetime()),
[ContainingRegistryElementID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [edw].[EntityColumns_RegistryElements] ADD CONSTRAINT [PK_EntityColumns_RegistryElements] PRIMARY KEY CLUSTERED  ([EntityColumnsRegistryElementsID]) ON [PRIMARY]
GO
ALTER TABLE [edw].[EntityColumns_RegistryElements] ADD CONSTRAINT [U_EntityColumns_RegistryElements] UNIQUE NONCLUSTERED  ([EntityColumnId], [RegistryElementId]) ON [PRIMARY]
GO
ALTER TABLE [edw].[EntityColumns_RegistryElements] ADD CONSTRAINT [FK_EntityColumns_RegistryElements_ContainingRegistryElementId] FOREIGN KEY ([ContainingRegistryElementID]) REFERENCES [rdd].[RegistryElements] ([RegistryElementId])
GO
ALTER TABLE [edw].[EntityColumns_RegistryElements] ADD CONSTRAINT [FK_EntityColumns_RegistryElements_EntityColumnId] FOREIGN KEY ([EntityColumnId]) REFERENCES [edw].[EntityColumns] ([EntityColumnId])
GO
ALTER TABLE [edw].[EntityColumns_RegistryElements] ADD CONSTRAINT [FK_EntityColumns_RegistryElements_RegistryElementId] FOREIGN KEY ([RegistryElementId]) REFERENCES [rdd].[RegistryElements] ([RegistryElementId])
GO
ALTER TABLE [edw].[EntityColumns_RegistryElements] ADD CONSTRAINT [FK_EntityColumns_RegistryElements_TimePartEntityColumnId] FOREIGN KEY ([TimePartEntityColumnId]) REFERENCES [edw].[EntityColumns] ([EntityColumnId])
GO
