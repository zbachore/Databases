CREATE TABLE [dbo].[ProjectDataElementCodingInstructions]
(
[Id] [int] NOT NULL,
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectDataElementCodingInstructions_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectDataElementCodingInstructions_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectDataElementCodingInstructions] ADD CONSTRAINT [ProjectDataElementCodingInstructions_PK] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
