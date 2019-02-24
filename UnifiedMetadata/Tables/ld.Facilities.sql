CREATE TABLE [ld].[Facilities]
(
[FacilityId] [int] NOT NULL,
[AHANumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FacilityName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
[UpdatedById] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [ld].[Facilities] ADD CONSTRAINT [PK__Faciliti__5FB08A74A1F7D7A4] PRIMARY KEY CLUSTERED  ([FacilityId]) ON [PRIMARY]
GO
