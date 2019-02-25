CREATE TABLE [dbo].[ProjectValueSetMedicationMembers]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectValueSetMedicationMembers_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectValueSetMedicationMembers_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectValueSetMedicationMembers] ADD CONSTRAINT [ProjectValueSetMedicationMembers_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectValueSetMedicationMembers] ADD CONSTRAINT [FK_ProjectValueSetMedicationMembers_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectValueSetMedicationMembers] WITH NOCHECK ADD CONSTRAINT [FK_ProjectValueSetMedicationMembers_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [cdd].[ValueSetMedicationMembers] ([ValueSetMemberId])
GO
ALTER TABLE [dbo].[ProjectValueSetMedicationMembers] NOCHECK CONSTRAINT [FK_ProjectValueSetMedicationMembers_ReferenceId]
GO
