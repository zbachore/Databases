CREATE TABLE [dbo].[ProjectMedications]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectMedications_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectMedications_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectMedications] ADD CONSTRAINT [ProjectMedications_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectMedications] ADD CONSTRAINT [FK_ProjectMedications_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectMedications] WITH NOCHECK ADD CONSTRAINT [FK_ProjectMedications_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [ld].[Medications] ([MedicationId])
GO
ALTER TABLE [dbo].[ProjectMedications] NOCHECK CONSTRAINT [FK_ProjectMedications_ReferenceId]
GO
