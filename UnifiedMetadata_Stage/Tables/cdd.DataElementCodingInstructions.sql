CREATE TABLE [cdd].[DataElementCodingInstructions]
(
[DataElementCodingInstructionId] [int] NOT NULL,
[DataElementId] [int] NOT NULL,
[CodingInstruction] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ValidStartDate] [datetime2] NULL,
[ValidEndDate] [datetime2] NULL,
[IsActive] [bit] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DataElementCodingInstructions_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DataElementCodingInstructions_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [cdd].[DataElementCodingInstructions] ADD CONSTRAINT [PK_DataElementCodingInstruction] PRIMARY KEY NONCLUSTERED  ([DataElementCodingInstructionId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_DataElementCodingInstruction_DataElement] ON [cdd].[DataElementCodingInstructions] ([DataElementId]) ON [PRIMARY]
GO
