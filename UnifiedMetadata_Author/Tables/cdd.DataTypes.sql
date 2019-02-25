CREATE TABLE [cdd].[DataTypes]
(
[DataTypeId] [int] NOT NULL IDENTITY(1, 1),
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
EXEC sp_addextendedproperty N'MS_Description', N'Defines the kind of data that can be included in a field. While most of the data types are derived from the HL7 data types, there may be few that are specific to ACC.', 'SCHEMA', N'cdd', 'TABLE', N'DataTypes', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Code used to identify the data type. Codes are defined by standards organization such as HL7.', 'SCHEMA', N'cdd', 'TABLE', N'DataTypes', 'COLUMN', N'DataTypeCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The assembly qualified name for the .net type representation.', 'SCHEMA', N'cdd', 'TABLE', N'DataTypes', 'COLUMN', N'DataTypeNetType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Define the source for the data type definition. Example: HL7', 'SCHEMA', N'cdd', 'TABLE', N'DataTypes', 'COLUMN', N'DataTypeSource'
GO
