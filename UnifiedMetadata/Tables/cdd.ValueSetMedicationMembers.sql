CREATE TABLE [cdd].[ValueSetMedicationMembers]
(
[ValueSetMemberId] [int] NOT NULL,
[MedicationId] [int] NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ValueSetMedicationMembers_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ValueSetMedicationMembers_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[ValueSetMedicationMembers] ADD CONSTRAINT [PK_ValueSetMedicationMembers] PRIMARY KEY CLUSTERED  ([ValueSetMemberId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ValueSetMedicationMembers_Medications] ON [cdd].[ValueSetMedicationMembers] ([MedicationId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ValueSetMedicationMembers_ValueSetMembers] ON [cdd].[ValueSetMedicationMembers] ([ValueSetMemberId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[ValueSetMedicationMembers] ADD CONSTRAINT [FK_ValueSetMedicationMembers_ValueSetMembers] FOREIGN KEY ([ValueSetMemberId]) REFERENCES [cdd].[ValueSetMembers] ([ValueSetMemberId])
GO
