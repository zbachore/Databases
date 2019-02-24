CREATE TABLE [dbo].[ProjectComments]
(
[ProjectCommentId] [int] NOT NULL,
[ProjectId] [int] NOT NULL,
[Comments] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ProjectComments_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ProjectComments_UpdatedDate] DEFAULT (sysdatetime()),
[CreatedBy] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentCommentId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectComments] ADD CONSTRAINT [ProjectComments_PK] PRIMARY KEY NONCLUSTERED  ([ProjectCommentId]) ON [PRIMARY]
GO
