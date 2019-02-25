CREATE TABLE [ld].[Composites]
(
[CompositeId] [int] NOT NULL IDENTITY(1, 1),
[CompositeName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CompositeDescription] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Composites_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Composites_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [ld].[Composites] ADD CONSTRAINT [PK_Composites] PRIMARY KEY CLUSTERED  ([CompositeId]) ON [PRIMARY]
GO
