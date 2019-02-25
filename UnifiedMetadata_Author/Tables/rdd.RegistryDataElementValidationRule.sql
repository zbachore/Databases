CREATE TABLE [rdd].[RegistryDataElementValidationRule]
(
[DataElementRuleID] [int] NOT NULL IDENTITY(1, 1),
[RegistryVersionID] [int] NULL,
[DataElementID] [int] NOT NULL,
[DataElementValidationClassifID] [int] NULL,
[ParentDataElementID] [int] NULL,
[ParentDataElementValueSetMemberID] [int] NULL,
[ParentDataElementBooleanValue] [bit] NOT NULL,
[ModifiedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ModifiedDate] [datetime2] NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryDataElementValidationRule_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryDataElementValidationRule_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'If parent element is a boolean the conditional value will be stored in this field. The value of this field will control the behavior of the data element field.', 'SCHEMA', N'rdd', 'TABLE', N'RegistryDataElementValidationRule', 'COLUMN', N'ParentDataElementBooleanValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Parent Value Controlling the Child Value. Value for this field should come from the value list defined for the parent element.', 'SCHEMA', N'rdd', 'TABLE', N'RegistryDataElementValidationRule', 'COLUMN', N'ParentDataElementValueSetMemberID'
GO
