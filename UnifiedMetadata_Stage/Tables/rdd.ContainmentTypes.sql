CREATE TABLE [rdd].[ContainmentTypes]
(
[ContainmentTypeId] [int] NOT NULL,
[ContainmentTypeName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContainmentTypeDescription] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ContainmentTypes_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ContainmentTypes_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [rdd].[ContainmentTypes] ADD CONSTRAINT [PK_ContainmentTypes] PRIMARY KEY CLUSTERED  ([ContainmentTypeId]) ON [PRIMARY]
GO
