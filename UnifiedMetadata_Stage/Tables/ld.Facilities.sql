CREATE TABLE [ld].[Facilities]
(
[AHANumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FacilityName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FacilityAddress] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FacilityState] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FacilityCity] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FacilityZipCode] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Facilities_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Facilities_UpdatedDate] DEFAULT (sysdatetime()),
[Active] [int] NULL,
[CreatedById] [int] NULL,
[UpdatedById] [int] NULL,
[FacilityID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [ld].[Facilities] ADD CONSTRAINT [PK__Faciliti__5FB08B9457780BF7] PRIMARY KEY CLUSTERED  ([FacilityID]) ON [PRIMARY]
GO
