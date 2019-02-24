CREATE TABLE [dbo].[ProjectStatusWorkflow]
(
[ProjectStatusWorkflowId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ProjectStatusWorkflow_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ProjectStatusWorkflow_UpdatedDate] DEFAULT (sysdatetime()),
[FromProjectStatusId] [int] NOT NULL,
[ToProjectStatusId] [int] NOT NULL,
[RoleId] [int] NOT NULL CONSTRAINT [DF__ProjectSt__RoleI__567ED357] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectStatusWorkflow] ADD CONSTRAINT [ProjectStatusWorkflow_PK] PRIMARY KEY NONCLUSTERED  ([ProjectStatusWorkflowId]) ON [PRIMARY]
GO
