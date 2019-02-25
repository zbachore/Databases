CREATE TABLE [dd].[ConstraintTypes]
(
[ConstraintTypeId] [int] NOT NULL IDENTITY(1, 1),
[ConstraintTypeName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConstraintTypeDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsRequired] [bit] NOT NULL CONSTRAINT [DF_ConstraintTypes_IsRequired] DEFAULT ((0)),
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ConstraintTypes_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ConstraintTypes_UpdatedDate] DEFAULT (sysdatetime()),
[ConstraintTypeMessage] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dd].[ConstraintTypes] ADD CONSTRAINT [PK_ConstraintTypes] PRIMARY KEY CLUSTERED  ([ConstraintTypeId]) ON [PRIMARY]
GO
