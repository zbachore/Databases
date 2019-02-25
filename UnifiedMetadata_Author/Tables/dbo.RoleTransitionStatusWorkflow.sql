CREATE TABLE [dbo].[RoleTransitionStatusWorkflow]
(
[RoleTransitionStatusWorkflowId] [int] NOT NULL IDENTITY(1, 1),
[ProjectStatusId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_RoleTransitionStatusWorkFlow_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_RoleTransitionStatusWorkFlow_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RoleTransitionStatusWorkflow] ADD CONSTRAINT [RoleTransitionStatusWorkFlow_PK] PRIMARY KEY NONCLUSTERED  ([RoleTransitionStatusWorkflowId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RoleTransitionStatusWorkflow] ADD CONSTRAINT [FK_RoleTransitionStatusWorkFlow_ProjectStatus] FOREIGN KEY ([ProjectStatusId]) REFERENCES [dbo].[ProjectStatus] ([ProjectStatusId])
GO
ALTER TABLE [dbo].[RoleTransitionStatusWorkflow] ADD CONSTRAINT [FK_RoleTransitionStatusWorkFlow_Roles] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles] ([RoleId])
GO
