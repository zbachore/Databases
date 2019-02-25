CREATE TABLE [cdd].[ValueSets]
(
[ValueSetId] [int] NOT NULL,
[ValueSetName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ValueSetOid] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDynamicList] [bit] NOT NULL,
[IsPermissibleValueList] [bit] NOT NULL,
[IsActive] [bit] NOT NULL,
[StartDate] [datetime2] NOT NULL,
[EndDate] [datetime2] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ValueSets_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ValueSets_UpdatedDate] DEFAULT (sysdatetime()),
[CodeSystemId] [int] NULL,
[Synonyms] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ValueSetDiscriminator] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [cdd].[ValueSets] ADD CONSTRAINT [PK_ValueSet] PRIMARY KEY NONCLUSTERED  ([ValueSetId]) ON [PRIMARY]
GO
