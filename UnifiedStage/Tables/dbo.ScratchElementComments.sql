CREATE TABLE [dbo].[ScratchElementComments]
(
[ScratchElementCommentsId] [int] NOT NULL IDENTITY(1, 1),
[ScratchElementId] [int] NOT NULL,
[Comment] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ScratchElementComments_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ScratchElementComments_UpdatedDate] DEFAULT (sysdatetime()),
[CreatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ScratchElementComments] ADD CONSTRAINT [ScratchElementCommentsId_PK] PRIMARY KEY NONCLUSTERED  ([ScratchElementCommentsId]) ON [PRIMARY]
GO
