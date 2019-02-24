CREATE TABLE [dd].[ConstraintDefinitionRelatedElementGroups]
(
[ConstraintDefinitionRelatedElementGroupId] [int] NOT NULL,
[GroupOperator] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GroupOrder] [int] NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ConstraintDefinitionRelatedElementGroups_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ConstraintDefinitionRelatedElementGroups_UpdatedDate] DEFAULT (sysdatetime()),
[UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dd].[ConstraintDefinitionRelatedElementGroups] ADD CONSTRAINT [PK_ConstraintDefRelElementGroups] PRIMARY KEY CLUSTERED  ([ConstraintDefinitionRelatedElementGroupId]) ON [PRIMARY]
GO
