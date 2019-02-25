CREATE TABLE [dbo].[Project]
(
[ProjectId] [int] NOT NULL,
[CreatedBy] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_Project_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedBy] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_Project_UpdatedDate] DEFAULT (sysdatetime()),
[ProjectName] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProjectDesc] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProjectStartDate] [datetime] NOT NULL CONSTRAINT [DF__Project__ProjectStartDate] DEFAULT (getdate()),
[ProjectEndDate] [datetime] NULL,
[ProjectStatusId] [int] NOT NULL,
[Tags] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RegistryVersionId] [int] NULL,
[StatusUpdateDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Project] ADD CONSTRAINT [PK__Project__761ABEF04984E600] PRIMARY KEY CLUSTERED  ([ProjectId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Project] ADD CONSTRAINT [unique_Project_ProjectName] UNIQUE NONCLUSTERED  ([ProjectName]) ON [PRIMARY]
GO
