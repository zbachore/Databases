CREATE TABLE [dbo].[ProjectFormPageLocations]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectFormPageLocations_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectFormPageLocations_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectFormPageLocations] ADD CONSTRAINT [ProjectFormPageLocations_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectFormPageLocations] ADD CONSTRAINT [FK_ProjectFormPageLocations_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectFormPageLocations] WITH NOCHECK ADD CONSTRAINT [FK_ProjectFormPageLocations_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [form].[FormPageLocations] ([FormPageLocationId])
GO
ALTER TABLE [dbo].[ProjectFormPageLocations] NOCHECK CONSTRAINT [FK_ProjectFormPageLocations_ReferenceId]
GO
