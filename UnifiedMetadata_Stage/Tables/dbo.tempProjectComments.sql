CREATE TABLE [dbo].[tempProjectComments]
(
[ProjectCommentId] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[Comments] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL,
[UpdatedDate] [datetime2] NOT NULL,
[CreatedBy] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentCommentId] [int] NULL
) ON [PRIMARY]
GO
