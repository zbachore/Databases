CREATE TABLE [cdd].[ValueSets_20180808B]
(
[ValueSetId] [int] NOT NULL IDENTITY(1, 1),
[ValueSetName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ValueSetOid] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDynamicList] [bit] NOT NULL,
[IsPermissibleValueList] [bit] NOT NULL,
[IsActive] [bit] NOT NULL,
[StartDate] [datetime2] NOT NULL,
[EndDate] [datetime2] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL,
[UpdatedDate] [datetime2] NOT NULL,
[CodeSystemId] [int] NULL,
[Synonyms] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
