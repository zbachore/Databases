CREATE TABLE [form].[FormTypes]
(
[FormTypeId] [int] NOT NULL,
[FormTypeName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FormTypeDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_FormTypes_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_FormTypes_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [form].[FormTypes] ADD CONSTRAINT [PK_FormTypes] PRIMARY KEY CLUSTERED  ([FormTypeId]) ON [PRIMARY]
GO
