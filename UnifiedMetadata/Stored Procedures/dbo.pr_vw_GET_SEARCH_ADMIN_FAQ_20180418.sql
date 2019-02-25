SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








--Exec [pr_vw_GET_SEARCH_ADMIN_FAQ] 3,null,null,null,null,null,null,null,null,'v2.0'
/*
--	Update History:
--		PMunikri11192012: Added TVT registry

*/
CREATE              PROCEDURE [dbo].[pr_vw_GET_SEARCH_ADMIN_FAQ_20180418]
(
 @PRODID INT= NULL,
 @uidclient INT=NULL,
  @SearchText VARCHAR(1000)=NULL,
 @SEQNUM VARCHAR(50) =NULL,
 @CATEGORY_ID INT= NULL,
 @FAQ_ID INT= NULL,
 @ELEMENT_Name VARCHAR(100)=NULL,
 @POSTED_START_DATE DATETIME =NULL,
 @POSTED_END_DATE DATETIME =NULL,
 @Version VARCHAR(20) = NULL,
 @RegistryVersionID INT = NULL
)
AS

--
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  -- Yang added on 10/17/2008
--

DECLARE @findStr VARCHAR(5)
DECLARE @replaceStr VARCHAR(5)
SET @findStr=','
SET @replaceStr=''','''
SET @ELEMENT_Name=REPLACE(@ELEMENT_Name,@findStr,@replaceStr)
DECLARE @QueryStr VARCHAR(8000)
DECLARE @SQLStatement VARCHAR(5000)
IF  @SEQNUM IS NOT NULL
	SET @QueryStr=  'c.uidSeqNum IN(' +  CAST(@SEQNUM AS VARCHAR)+ ')'
IF  @ELEMENT_Name IS NOT NULL
IF  @QueryStr IS NOT NULL
	BEGIN
		SET @QueryStr= '(' + @QueryStr + ' OR '
		SET @QueryStr= @QueryStr + 'a.ElementName in (''' + CAST(@ELEMENT_Name AS VARCHAR) + '''))'
	END
ELSE
	SET @QueryStr=  'a.ElementName in (''' + CAST(@ELEMENT_Name AS VARCHAR) + ''')'
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
else
	SET @QueryStr=  'a.uidFAQCategory = ' +  CAST(@CATEGORY_ID AS VARCHAR)

--Shalini Nethi ticket#10673 05272009 START
	IF @Version is Not NULL AND @PRODID <> 3
	IF @QueryStr IS NOT NULL
	BEGIN
	SET @QueryStr= @QueryStr + ' AND '
	SET @QueryStr = @QueryStr + 'a.Version = '''+@Version + ''''
	END
	else
	SET @QueryStr = 'a.Version = ''' + @Version + ''''
--Shalini Nethi ticket#10673 END

--IF  @RegistryVersionID IS NOT NULL 
--IF  @QueryStr IS NOT NULL
--	BEGIN
--		SET @QueryStr= @QueryStr + ' AND '
--		SET @QueryStr= @QueryStr + 'a.RegistryVersionID =' + CAST(@RegistryVersionID AS VARCHAR)
--	END
--else
--	SET @QueryStr=  'a.RegistryVersionID = ' +  CAST(@RegistryVersionID AS VARCHAR)
	
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
else
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
		SET @QueryStr= @QueryStr + 'a.PostedDate >= ''' + CONVERT(varchar,@POSTED_START_DATE)  + ''''
	END
else
	SET @QueryStr=  'a.PostedDate   >= ''' + CONVERT(varchar,@POSTED_START_DATE)  + ''''
IF  @POSTED_END_DATE IS NOT NULL
IF  @QueryStr IS NOT NULL
	BEGIN
		SET @QueryStr= @QueryStr + ' AND '
		SET @QueryStr= @QueryStr + 'a.PostedDate <= ''' + CONVERT(varchar, @POSTED_END_DATE)  + ''''
	END
else
	SET @QueryStr=  'a.PostedDate <= ''' + CONVERT(varchar,@POSTED_END_DATE) + ''''
print @QueryStr
-- Products - ICD, AFib
IF @PRODID in (3,38)
	BEGIN	   
		SET @SQLStatement='SELECT a.uidFAQ,a.uidFAQCategory as FAQ_CATEGORY,(CASE WHEN c.uidSeqNum is Null THEN 0 ELSE c.uidSeqNum END)as SEQNUM,(CAST(a.uidFAQ as VARCHAR) + ''__'' +   CAST((CASE WHEN c.uidSeqNum is Null THEN ''0'' ELSE c.uidSeqNum END) as VARCHAR))as FAQ_ID_SEQNUM,(CASE WHEN a.tmpSeqNum is Null THEN ''0'' ELSE a.tmpSeqNum END)as FAQ_TMP_SEQNUM,(CASE WHEN e.[DataElementName] is Null THEN '' '' ELSE e.[DataElementName] END) as ELEMENT_NAME,a.Question,(CASE WHEN a.Answer is NULL then '''' ELSE a.Answer END)as FAQ_ANSWER,CONVERT(varchar(12), a.PostedDate, 1) AS FAQ_POSTED_DATE, b.CategoryName ,(d.GivenName + CHAR(9) + d.SurName) AS USERNAME, EMAIL.EMAIL as EMAIL, a.isNotifyUser FROM NCommon.dbo.tblFAQ a Left Join NCommon.dbo.tblUser d on a.PostedUserID=d.UidUser '
		SET @SQLStatement = @SQLStatement+ 'inner join NCommon.dbo.tblClientUser as EMAIL on EMAIL.uidUser=d.uidUser and EMAIL.uidclient=a.uidclient Left Join NCommon.dbo.tblFAQSeqNum c on a.uidFAQ=c.uidFAQ Left join vTechincalDataDictionary e on c.uidSeqNum=e.DataElementSeq  and e.RegistryId = 160 and e.RegistryVersionId = a.RegistryVersionID , NCommon.dbo.tblFAQCategory b WHERE a.uidFAQCategory = b.uidCategory AND a.RegistryVersionID = ' + CAST(@RegistryVersionID as varchar) + ' and a.uidProduct='+ CAST(@PRODID as Varchar(10))
	END
IF  @QueryStr IS NOT NULL
	SET @SQLStatement= @SQLStatement + ' AND ' + @QueryStr
SET @SQLStatement= @SQLStatement + ' ORDER BY a.uidFAQ DESC'
print @SQLStatement
EXEC(@SQLStatement)
  
RETURN

















GO
