CREATE TABLE [dbo].[Facilities]
(
[AHANumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FacilityName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FacilityAddress] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FacilityState] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FacilityCity] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FacilityZipCode] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Facilities_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Facilities_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Facilities] ADD CONSTRAINT [PK_Facilities] PRIMARY KEY CLUSTERED  ([AHANumber]) ON [PRIMARY]
GO
