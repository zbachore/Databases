CREATE TABLE [dbo].[ProjectStatusWorkflow]
(
[ProjectStatusWorkflowId] [int] NOT NULL IDENTITY(1, 1),
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectStatusWorkflow_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF_ProjectStatusWorkflow_UpdatedDate] DEFAULT (sysdatetime()),
[FromProjectStatusId] [int] NOT NULL,
[ToProjectStatusId] [int] NOT NULL,
[RoleId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectStatusWorkflow] ADD CONSTRAINT [ProjectStatusWorkflow_PK] PRIMARY KEY NONCLUSTERED  ([ProjectStatusWorkflowId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectStatusWorkflow] ADD CONSTRAINT [FK_ProjectStatusWorkflow_FromProjectStatus] FOREIGN KEY ([FromProjectStatusId]) REFERENCES [dbo].[ProjectStatus] ([ProjectStatusId])
GO
ALTER TABLE [dbo].[ProjectStatusWorkflow] ADD CONSTRAINT [FK_ProjectStatusWorkflow_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles] ([RoleId])
GO
ALTER TABLE [dbo].[ProjectStatusWorkflow] ADD CONSTRAINT [FK_ProjectStatusWorkflow_ToProjectStatus] FOREIGN KEY ([ToProjectStatusId]) REFERENCES [dbo].[ProjectStatus] ([ProjectStatusId])
GO
