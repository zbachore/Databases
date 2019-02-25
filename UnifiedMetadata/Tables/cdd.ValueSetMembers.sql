CREATE TABLE [cdd].[ValueSetMembers]
(
[ValueSetMemberId] [int] NOT NULL,
[ValueSetId] [int] NOT NULL,
[DisplayOrder] [int] NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ValueSetMembers_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ValueSetMembers_UpdatedDate] DEFAULT (sysdatetime()),
[ValueSetMemberLabel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartDate] [datetime2] NOT NULL,
[EndDate] [datetime2] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[ValueSetMembers] ADD CONSTRAINT [PK_ValueSetMember] PRIMARY KEY CLUSTERED  ([ValueSetMemberId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ValueSetMembers_ValueSets] ON [cdd].[ValueSetMembers] ([ValueSetId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[ValueSetMembers] ADD CONSTRAINT [FK_ValueSetMembers_ValueSets] FOREIGN KEY ([ValueSetId]) REFERENCES [cdd].[ValueSets] ([ValueSetId])
GO
