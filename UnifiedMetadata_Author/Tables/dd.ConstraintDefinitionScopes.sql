CREATE TABLE [dd].[ConstraintDefinitionScopes]
(
[ConstraintDefinitionScopeId] [int] NOT NULL IDENTITY(1, 1),
[ConstraintDefinitionScopeName] [nvarchar] (510) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConstraintDefinitionScopeDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ConstraintDefinitionScopes_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ConstraintDefinitionScopes_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dd].[ConstraintDefinitionScopes] ADD CONSTRAINT [PK_ConstraintDefinitionScopes] PRIMARY KEY CLUSTERED  ([ConstraintDefinitionScopeId]) ON [PRIMARY]
GO
