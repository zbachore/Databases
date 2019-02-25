CREATE TABLE [cdd].[DataTypes]
(
[DataTypeId] [int] NOT NULL,
[DataTypeCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataTypeSource] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataTypeName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataTypeShortName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataTypeNetType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DataTypes_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DataTypes_UpdatedDate] DEFAULT (sysdatetime()),
[DataTypeAlternateName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [cdd].[DataTypes] ADD CONSTRAINT [PK_DataType] PRIMARY KEY NONCLUSTERED  ([DataTypeId]) ON [PRIMARY]
GO
