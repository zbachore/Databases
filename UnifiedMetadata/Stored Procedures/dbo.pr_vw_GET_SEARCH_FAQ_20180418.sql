SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- dbo.pr_vw_GET_SEARCH_FAQ 8, 999999, null, null, null, null, null, null, null, 'v1.0'
/*
--	Update History:
--      ASuyambu - Unable to access UnifiedMetadata from NCommon due to Security Issues. Registries with RegistryVersionId need to have an If clause in the SP
--		01092017 - Added Support for Afib Faq Search
*/

CREATE PROCEDURE [dbo].[pr_vw_GET_SEARCH_FAQ_20180418]
(
 @PRODID INT = NULL,
 @uidclient INT = NULL,
 @SearchText VARCHAR(1000)=NULL,
 @SEQNUM VARCHAR(100) =NULL,
 @CATEGORY_ID INT= NULL,
 @FAQ_ID INT= NULL,
 @ELEMENT_Name VARCHAR(150)=NULL,
 @POSTED_START_DATE DATETIME =NULL,
 @POSTED_END_DATE DATETIME =NULL,
 @Version VARCHAR(20) = NULL,
 @RegistryVersionID INT = NULL
)
AS
DECLARE @findStr varchar(5)
DECLARE @replaceStr varchar(5)
set @findStr=','
set @replaceStr=''','''
SET @ELEMENT_Name=REPLACE(@ELEMENT_Name,@findStr,@replaceStr)
--print (@ELEMENT_Name)
DECLARE @QueryStr VARCHAR(8000)
DECLARE @SQLStatement VARCHAR(5000)
DECLARE @ELEMENTNAME VARCHAR(50)
IF @PRODID = 2
  IF @Version ='v3.0'
  SET @ELEMENTNAME='e.[V3 Element Name]'
  ELSE IF @Version ='v4.0'
  SET @ELEMENTNAME = 'e.ElementFullName'  
ELSE IF @PRODID = 3
BEGIN
	IF @Version ='v1.0'
		SET @ELEMENTNAME='e.FieldName'
	ELSE IF @Version='v2.0'
		 SET @ELEMENTNAME = 'e.ElementFullName'  
  END
ELSE IF @PRODID = 4
  SET @ELEMENTNAME='e.FieldName'
ELSE IF @PRODID = 5
  SET @ELEMENTNAME = 'e.FullName'
ELSE IF @PRODID = 38
 SET @ELEMENTNAME = 'e.ElementFullName'  
  
  
IF  @SEQNUM IS NOT NULL
	SET @QueryStr=  'c.uidSeqNum IN(' +  CAST(@SEQNUM AS VARCHAR)+ ')'
-- Duplicate condition w/ @SEQNUM - ticket #11706
/*
IF  @ELEMENT_Name IS NOT NULL
IF  @QueryStr IS NOT NULL
	BEGIN
		SET @QueryStr= '(' + @QueryStr + ' OR '
		SET @QueryStr= @QueryStr + @ELEMENTNAME + ' in (''' + CAST(@ELEMENT_Name AS VARCHAR(150)) + '''))'
	END
else
	SET @QueryStr=  @ELEMENTNAME + ' in (''' + CAST(@ELEMENT_Name AS VARCHAR(150)) + ''')'
*/
IF  @FAQ_ID IS NOT NULL
IF  @QueryStr IS NOT NULL
	BEGIN
		SET @QueryStr= @QueryStr + ' AND '
		SET @QueryStr= @QueryStr + 'a.uidFAQ =' + CAST(@FAQ_ID AS VARCHAR)
	END
ELSE
	SET @QueryStr=  'a.uidFAQ = ' +  CAST(@FAQ_ID AS VARCHAR)
IF  @CATEGORY_ID IS NOT NULL
IF  @QueryStr IS NOT NULL
	BEGIN
		SET @QueryStr= @QueryStr + ' AND '
		SET @QueryStr= @QueryStr + 'a.uidFAQCategory =' + CAST(@CATEGORY_ID AS VARCHAR)
	END
ELSE
	SET @QueryStr=  'a.uidFAQCategory = ' +  CAST(@CATEGORY_ID AS VARCHAR)
--Shalini Nethi ticket#10673 05272009 START
	IF @Version IS NOT NULL AND @PRODID != 3
	IF @QueryStr IS NOT NULL
	BEGIN
	SET @QueryStr= @QueryStr + ' AND '
	SET @QueryStr = @QueryStr + 'a.Version = '''+@Version + ''''
	END
	ELSE
	SET @QueryStr = 'a.Version = ''' + @Version + ''''
--Shalini Nethi ticket#10673 END
IF  @SearchText IS NOT NULL
IF  @QueryStr IS NOT NULL
	BEGIN
		SET @QueryStr= @QueryStr + ' AND '
		SET @QueryStr= @QueryStr + '(charindex(''' + @SearchText + ''',a.Question)>0 OR '
		SET @QueryStr= @QueryStr + 'charindex(''' + @SearchText + ''',a.Answer)>0 OR '
		SET @QueryStr= @QueryStr + 'charindex(''' + @SearchText + ''',c.uidSeqNum)>0 OR '
		SET @QueryStr= @QueryStr + 'charindex(''' + @SearchText + ''',a.ElementName)>0 OR '
		SET @QueryStr= @QueryStr + 'charindex(''' + @SearchText + ''',b.CategoryName)>0 ) '
	END
ELSE
BEGIN
		SET @QueryStr= '(charindex(''' + @SearchText + ''',a.Question)>0 OR '
		SET @QueryStr= @QueryStr + 'charindex(''' + @SearchText + ''',a.Answer)>0 OR '
		SET @QueryStr= @QueryStr + 'charindex(''' + @SearchText + ''',c.uidSeqNum)>0 OR '
		SET @QueryStr= @QueryStr + 'charindex(''' + @SearchText + ''',a.ElementName)>0 OR '
		SET @QueryStr= @QueryStr + 'charindex(''' + @SearchText + ''',b.CategoryName)>0 ) '
END
IF  @POSTED_START_DATE IS NOT NULL
IF  @QueryStr IS NOT NULL
	BEGIN
		SET @QueryStr= @QueryStr + ' AND '
		SET @QueryStr= @QueryStr + ' a.PostedDate >= ''' + CONVERT(VARCHAR,@POSTED_START_DATE,101)  + ''''
	END
ELSE
	SET @QueryStr=  'a.PostedDate   >= ''' + CONVERT(VARCHAR,@POSTED_START_DATE,101)  + ''''
IF  @POSTED_END_DATE IS NOT NULL
IF  @QueryStr IS NOT NULL
	BEGIN
		SET @QueryStr= @QueryStr + ' AND '
		SET @QueryStr= @QueryStr + ' a.PostedDate <= ''' + CONVERT(VARCHAR, @POSTED_END_DATE,101)  + ''''
	END
ELSE
	SET @QueryStr=  'a.PostedDate <= ''' + CONVERT(VARCHAR,@POSTED_END_DATE) + ''''
	

IF @PRODID = 3 
 BEGIN
  SET @SQLStatement='SELECT a.uidFAQ as FAQ_ID,b.CategoryName as CATEGORY_NAME ,c.uidSeqNum as SEQNUM,(CASE WHEN e.[CodingInstruction] is Null THEN '''' ELSE e.[CodingInstruction] END) as Definition,(CAST(a.uidFAQ as VARCHAR) + '','' +   CAST(c.uidSeqNum as VARCHAR))as FAQ_ID_SEQNUM, (CASE WHEN e.[DataElementName] is Null THEN '' '' ELSE e.[DataElementName] END) as ELEMENT_NAME,a.Question as FAQ_QUESTION,isnull(a.Answer,'''') as FAQ_ANSWER,CONVERT(varchar(12), a.PostedDate, 1) AS FAQ_POSTED_DATE, (d.GivenName + CHAR(9) + d.SurName) AS USERNAME, EMAIL.EMAIL as EMAIL, a.isNotifyUser  FROM NCommon.dbo.tblFAQ a Left Join NCommon.dbo.tblUser d on a.PostedUserID=d.UidUser '
  SET @SQLStatement = @SQLStatement+ 'inner join NCommon.dbo.tblClientUser as EMAIL on EMAIL.uidUser=d.uidUser and EMAIL.uidclient=a.uidclient,NCommon.dbo.tblFAQCategory b,NCommon.dbo.tblFAQSeqNum c Left join dbo.vTechincalDataDictionary e on c.uidSeqNum=e.DataElementSeq  and e.RegistryId = 160 and e.RegistryVersionId = ' + CAST(@RegistryVersionID AS VARCHAR) + ' WHERE a.uidFAQCategory = b.uidCategory AND a.uidFAQ=c.uidFAQ and a.uidProduct=' + CAST(@PRODID AS VARCHAR(15)) + ' and a.RegistryVersionID ='  + CAST(@RegistryVersionID AS VARCHAR)
   --END
 END  

 IF @PRODID = 38
 BEGIN
  SET @SQLStatement='SELECT a.uidFAQ as FAQ_ID,b.CategoryName as CATEGORY_NAME ,c.uidSeqNum as SEQNUM,(CASE WHEN e.[CodingInstruction] is Null THEN '''' ELSE e.[CodingInstruction] END) as Definition,(CAST(a.uidFAQ as VARCHAR) + '','' +   CAST(c.uidSeqNum as VARCHAR))as FAQ_ID_SEQNUM, (CASE WHEN e.[DataElementName] is Null THEN '' '' ELSE e.[DataElementName] END) as ELEMENT_NAME,a.Question as FAQ_QUESTION,isnull(a.Answer,'''') as FAQ_ANSWER,CONVERT(varchar(12), a.PostedDate, 1) AS FAQ_POSTED_DATE, (d.GivenName + CHAR(9) + d.SurName) AS USERNAME, EMAIL.EMAIL as EMAIL, a.isNotifyUser  FROM NCommon.dbo.tblFAQ a Left Join NCommon.dbo.tblUser d on a.PostedUserID=d.UidUser '
  SET @SQLStatement = @SQLStatement+ 'inner join NCommon.dbo.tblClientUser as EMAIL on EMAIL.uidUser=d.uidUser and EMAIL.uidclient=a.uidclient,NCommon.dbo.tblFAQCategory b,NCommon.dbo.tblFAQSeqNum c Left join dbo.vTechincalDataDictionary e on c.uidSeqNum=e.DataElementSeq  and e.RegistryId = 220 and e.RegistryVersionId = ' + CAST(@RegistryVersionID AS VARCHAR) + ' WHERE a.uidFAQCategory = b.uidCategory AND a.uidFAQ=c.uidFAQ and a.uidProduct=' + CAST(@PRODID AS VARCHAR(15)) + ' and a.RegistryVersionID ='  + CAST(@RegistryVersionID AS VARCHAR)
   --END
 END  

IF  @QueryStr IS NOT NULL
	SET @SQLStatement= @SQLStatement + ' AND ' + @QueryStr
--SET @SQLStatement= @SQLStatement + ' ORDER BY a.uidFAQCategory asc,c.uidSeqNum asc,PostedDate asc'
SET @SQLStatement= @SQLStatement + ' ORDER BY PostedDate desc, a.uidFAQCategory asc,c.uidSeqNum asc'


PRINT (@SQLStatement)
EXEC(@SQLStatement)

RETURN
GO
