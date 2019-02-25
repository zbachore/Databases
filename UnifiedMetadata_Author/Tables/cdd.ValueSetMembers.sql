CREATE TABLE [cdd].[ValueSetMembers]
(
[ValueSetMemberId] [int] NOT NULL IDENTITY(1, 1),
[ValueSetId] [int] NOT NULL,
[DisplayOrder] [int] NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ValueSetMembers_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ValueSetMembers_UpdatedDate] DEFAULT (sysdatetime()),
[ValueSetMemberLabel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartDate] [datetime] NOT NULL CONSTRAINT [DF_ValueSetMembers_StartDate] DEFAULT ('2016-01-01'),
[EndDate] [datetime] NOT NULL CONSTRAINT [DF_ValueSetMembers_EndDate] DEFAULT ('9999-12-31')
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[ValueSetMembers] ADD CONSTRAINT [PK_ValueSetMember] PRIMARY KEY CLUSTERED  ([ValueSetMemberId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ValueSetMembers_ValueSets] ON [cdd].[ValueSetMembers] ([ValueSetId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[ValueSetMembers] ADD CONSTRAINT [FK_ValueSetMembers_ValueSets] FOREIGN KEY ([ValueSetId]) REFERENCES [cdd].[ValueSets] ([ValueSetId])
GO
