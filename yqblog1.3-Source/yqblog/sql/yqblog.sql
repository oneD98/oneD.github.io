/****** Object:  Table [dbo].[blog_roles]    Script Date: 10/21/2013 16:08:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[blog_roles](
	[roleid] [int] NOT NULL,
	[rolename] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_blog_roles] PRIMARY KEY CLUSTERED 
(
	[roleid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[blog_article]    Script Date: 10/21/2013 16:08:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[blog_article](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[typeid] [int] NOT NULL,
	[cateid] [int] NOT NULL,
	[catepath] [nvarchar](50) NOT NULL,
	[articleid] [bigint] NOT NULL,
	[parentid] [bigint] NOT NULL,
	[layer] [int] NOT NULL,
	[subcount] [int] NOT NULL,
	[userid] [bigint] NOT NULL,
	[username] [nchar](20) NOT NULL,
	[title] [nvarchar](200) NOT NULL,
	[summary] [nvarchar](500) NOT NULL,
	[content] [ntext] NOT NULL,
	[viewcount] [int] NOT NULL,
	[orderid] [int] NOT NULL,
	[replypermit] [tinyint] NOT NULL,
	[status] [tinyint] NOT NULL,
	[ip] [nvarchar](20) NOT NULL,
	[favor] [int] NOT NULL,
	[against] [int] NOT NULL,
	[iscommend] [tinyint] NOT NULL,
	[istop] [tinyint] NOT NULL,
	[createdate] [datetime] NOT NULL,
	[lastreplydate] [datetime] NOT NULL,
	[lastreplyuser] [nchar](20) NOT NULL,
	[lang] [nchar](10) NOT NULL,
	[articletypeid] [int] NOT NULL,
	[rename] [nvarchar](60) NOT NULL,
	[isindextop] [tinyint] NOT NULL,
 CONSTRAINT [PK__blog_arti__3213E83F117F9D94] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[blog_articledetail]    Script Date: 10/21/2013 16:08:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[blog_articledetail](
	[articleid] [bigint] NOT NULL,
	[seotitle] [nvarchar](500) NOT NULL,
	[seodescription] [nvarchar](1000) NOT NULL,
	[seokeywords] [nvarchar](500) NOT NULL,
	[seometas] [nvarchar](1000) NOT NULL,
	[tags] [nvarchar](60) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[articleid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[blog_logicDeleteArticle]    Script Date: 10/21/2013 16:09:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[blog_logicDeleteArticle]
@aid bigint
as
declare @layer int
declare @articleid bigint
select @layer=layer,@articleid=articleid from blog_article where id=@aid
begin    
    update blog_article set status=2 where id=@aid    
	if @layer=1        
		begin        
			update blog_article 
			set subcount=(select count(1) from blog_article where layer=@layer and articleid=@articleid and status=1)
			where id=@articleid 
		end       
	select @@ERROR
end
GO
/****** Object:  Table [dbo].[blog_users]    Script Date: 10/21/2013 16:09:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[blog_users](
	[userid] [bigint] IDENTITY(1,1) NOT NULL,
	[roleid] [int] NOT NULL,
	[username] [nvarchar](50) NOT NULL,
	[userpwd] [nvarchar](100) NOT NULL,
	[userstate] [int] NOT NULL,
	[usercreatedate] [datetime] NOT NULL,
	[lastlogindate] [datetime] NOT NULL,
	[lastactivitydate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[userid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[blog_userprofile]    Script Date: 10/21/2013 16:09:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[blog_userprofile](
	[userid] [bigint] NOT NULL,
	[gender] [int] NULL,
	[nickname] [nvarchar](100) NULL,
	[signature] [nvarchar](500) NULL,
	[intro] [nvarchar](2000) NULL,
	[birth] [datetime] NULL,
	[location] [nvarchar](500) NULL,
	[website] [nvarchar](500) NULL,
	[qq] [nvarchar](50) NULL,
	[sina] [nvarchar](200) NULL,
	[facebook] [nvarchar](200) NULL,
	[twitter] [nvarchar](200) NULL,
	[medals] [nvarchar](500) NULL,
	[phone] [nvarchar](50) NULL,
	[email] [nvarchar](100) NULL,
	[isSendEmail] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[userid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[blog_updatearticle]    Script Date: 10/21/2013 16:09:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[blog_updatearticle]
@aid bigint,
@typeid int,
@cateid int,
@catepath nvarchar(200),
@parentid bigint,
@title nvarchar(200),
@summary nvarchar(500),
@content ntext,
@replypermit tinyint,
@status tinyint,
@seotitle nvarchar(500),
@seodescription nvarchar(1000),
@seokeywords nvarchar(500),
@seometas nvarchar(1000),
@rename nvarchar(60),
@tags nvarchar(60),
@iscommend tinyint,
@istop tinyint,
@isindextop tinyint,
@articletypeid int,
@layer int

as
begin
    update blog_article set typeid=@typeid,cateid=@cateid,catepath=@catepath,title=@title,summary=@summary,[content]=@content,replypermit=@replypermit,[status]=@status,iscommend=@iscommend,[istop]=@istop,[isindextop]=@isindextop,articletypeid=@articletypeid,rename=@rename where id=@aid
    
    if @layer=0
        begin
            delete from blog_articledetail where articleid=@aid
            if(LTRIM(@seotitle+@seodescription+@seokeywords+@seometas+@tags)<>'')
				begin
					insert into blog_articledetail(articleid,seotitle,seodescription,seokeywords,seometas,tags) VALUES(@aid,@seotitle,@seodescription,@seokeywords,@seometas,@tags)
				end
        end
   select @@ERROR
end
GO
/****** Object:  StoredProcedure [dbo].[blog_deletearticle]    Script Date: 10/21/2013 16:09:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[blog_deletearticle]
@aid bigint
as
declare @layer int
declare @articleid bigint
select @layer=layer,@articleid=articleid from blog_article where id=@aid
begin    
	if @layer=0        
		begin            
			delete from blog_article where articleid=@aid            
			delete from blog_articledetail where articleid=@aid 
		end    
	else        
		begin            
			delete from blog_article where id=@aid  
			update blog_article 
			set subcount=(select count(1) from blog_article where layer=@layer and articleid=@articleid and status=1)
			where id=@articleid
		end   
	select @@ERROR
end
GO
/****** Object:  StoredProcedure [dbo].[blog_createarticle]    Script Date: 10/21/2013 16:09:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[blog_createarticle]
@typeid int,
@cateid int,
@catepath nvarchar(100),
@articleid bigint,
@parentid bigint,
@layer int,
@userid bigint,
@username nchar(20),
@title nvarchar(200),
@summary nvarchar(500),
@content ntext,
@replypermit tinyint,
@status tinyint,
@ip nvarchar(20),
@seotitle nvarchar(500),
@seodescription nvarchar(1000),
@seokeywords nvarchar(500),
@seometas nvarchar(1000),
@rename nvarchar(60),
@tags nvarchar(60),
@iscommend tinyint,
@istop tinyint,
@isindextop tinyint,
@createdate datetime,
@lang nchar(10),
@articletypeid int

as

declare @aid int
declare @currentOrder int

if @layer=0
	select @currentOrder=isnull(max(orderid),0)+1 from blog_article where cateid=@cateid
else
	select @currentOrder=isnull(max(orderid),0)+1 from blog_article where layer=@layer and articleid=@articleid

insert into 
blog_article(typeid,cateid ,catepath ,articleid ,parentid ,layer ,userid ,username ,title ,summary ,[content], replypermit, [status], ip ,lastreplydate,lastreplyuser,iscommend,istop,isindextop,orderid,createdate,lang,articletypeid,rename)
values(@typeid,@cateid ,@catepath ,@articleid ,@parentid ,@layer ,@userid ,@username ,@title ,@summary ,@content, @replypermit, @status ,@ip ,@createdate,@username,@iscommend,@istop,@isindextop,@currentOrder,@createdate,@lang,@articletypeid,@rename)

set @aid=SCOPE_IDENTITY()

if @@ERROR=0
begin
    if @layer=0
        begin
            update blog_article set articleid=@aid WHERE id=@aid
            if(LTRIM(@seotitle+@seodescription+@seokeywords+@seometas+@tags)<>'')
				begin
					insert into blog_articledetail(articleid,seotitle,seodescription,seokeywords,seometas,tags) VALUES(@aid,@seotitle,@seodescription,@seokeywords,@seometas,@tags)
				end
        end
    else
        begin
			update blog_article 
			set subcount=(select count(1) from blog_article where layer=@layer and articleid=@articleid),
			lastreplydate=@createdate,lastreplyuser=@username
			where id=@articleid
        end
end

SELECT @aid as articleid
GO
/****** Object:  View [dbo].[blog_varticle]    Script Date: 10/21/2013 16:09:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[blog_varticle]
as
select a.*,
(case a.rename when '' then cast(a.id as varchar) else a.rename end) as url,
isnull(seotitle,'') as seotitle,
isnull(seodescription,'') as seodescription,
isnull(seokeywords,'') as seokeywords,
isnull(seometas,'') as seometas,
isnull(tags,'') as tags
from blog_article a
left join blog_articledetail b
on a.id=b.articleid
where a.layer=0
GO
/****** Object:  View [dbo].[blog_vuser]    Script Date: 10/21/2013 16:09:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[blog_vuser] as
select a.*,
b.gender,
b.nickname,
b.signature,
b.intro,
b.birth,
b.location,
b.website,
b.qq,
b.sina,
b.facebook,
b.twitter,
b.medals,
b.phone,
b.email,
b.isSendEmail
 from blog_users a
left join blog_userprofile b
on a.userid=b.userid
GO
/****** Object:  Default [df_blog_article_typeid]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_typeid]  DEFAULT ((0)) FOR [typeid]
GO
/****** Object:  Default [df_blog_article_cateid]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_cateid]  DEFAULT ((0)) FOR [cateid]
GO
/****** Object:  Default [df_blog_article_catepath]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_catepath]  DEFAULT ('0') FOR [catepath]
GO
/****** Object:  Default [df_blog_article_articleid]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_articleid]  DEFAULT ((0)) FOR [articleid]
GO
/****** Object:  Default [df_blog_article_parentid]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_parentid]  DEFAULT ((0)) FOR [parentid]
GO
/****** Object:  Default [df_blog_article_layer]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_layer]  DEFAULT ((0)) FOR [layer]
GO
/****** Object:  Default [df_blog_article_subcount]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_subcount]  DEFAULT ((0)) FOR [subcount]
GO
/****** Object:  Default [df_blog_article_userid]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_userid]  DEFAULT ((0)) FOR [userid]
GO
/****** Object:  Default [df_blog_article_username]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_username]  DEFAULT ('') FOR [username]
GO
/****** Object:  Default [df_blog_article_title]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_title]  DEFAULT ('') FOR [title]
GO
/****** Object:  Default [df_blog_article_summary]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_summary]  DEFAULT ('') FOR [summary]
GO
/****** Object:  Default [df_blog_article_content]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_content]  DEFAULT ('') FOR [content]
GO
/****** Object:  Default [df_blog_article_viewcount]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_viewcount]  DEFAULT ((0)) FOR [viewcount]
GO
/****** Object:  Default [df_blog_article_orderid]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_orderid]  DEFAULT ((1)) FOR [orderid]
GO
/****** Object:  Default [df_blog_article_replypermit]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_replypermit]  DEFAULT ((1)) FOR [replypermit]
GO
/****** Object:  Default [df_blog_article_status]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_status]  DEFAULT ((1)) FOR [status]
GO
/****** Object:  Default [df_blog_article_ip]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_ip]  DEFAULT ('') FOR [ip]
GO
/****** Object:  Default [df_blog_article_favor]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_favor]  DEFAULT ((0)) FOR [favor]
GO
/****** Object:  Default [df_blog_article_against]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_against]  DEFAULT ((0)) FOR [against]
GO
/****** Object:  Default [df_blog_article_iscommend]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_iscommend]  DEFAULT ((2)) FOR [iscommend]
GO
/****** Object:  Default [df_blog_article_istop]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_istop]  DEFAULT ((2)) FOR [istop]
GO
/****** Object:  Default [df_blog_article_createdate]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_createdate]  DEFAULT (getdate()) FOR [createdate]
GO
/****** Object:  Default [df_blog_article_lastreplydate]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_lastreplydate]  DEFAULT (getdate()) FOR [lastreplydate]
GO
/****** Object:  Default [df_blog_article_lastreplyuser]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_lastreplyuser]  DEFAULT ('') FOR [lastreplyuser]
GO
/****** Object:  Default [df_blog_article_lang]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_lang]  DEFAULT ('') FOR [lang]
GO
/****** Object:  Default [df_blog_article_articletypeid]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_articletypeid]  DEFAULT ((0)) FOR [articletypeid]
GO
/****** Object:  Default [df_blog_article_rename]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_article] ADD  CONSTRAINT [df_blog_article_rename]  DEFAULT ('') FOR [rename]
GO
/****** Object:  Default [df_blog_detail_articleid]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_articledetail] ADD  CONSTRAINT [df_blog_detail_articleid]  DEFAULT ((0)) FOR [articleid]
GO
/****** Object:  Default [df_blog_detail_title]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_articledetail] ADD  CONSTRAINT [df_blog_detail_title]  DEFAULT ('') FOR [seotitle]
GO
/****** Object:  Default [df_blog_detail_description]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_articledetail] ADD  CONSTRAINT [df_blog_detail_description]  DEFAULT ('') FOR [seodescription]
GO
/****** Object:  Default [df_blog_detail_keywords]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_articledetail] ADD  CONSTRAINT [df_blog_detail_keywords]  DEFAULT ('') FOR [seokeywords]
GO
/****** Object:  Default [df_blog_detail_metas]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_articledetail] ADD  CONSTRAINT [df_blog_detail_metas]  DEFAULT ('') FOR [seometas]
GO
/****** Object:  Default [df_blog_detail_tags]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_articledetail] ADD  CONSTRAINT [df_blog_detail_tags]  DEFAULT ('') FOR [tags]
GO
/****** Object:  Default [df_blog_users_userstate]    Script Date: 10/21/2013 16:09:00 ******/
ALTER TABLE [dbo].[blog_users] ADD  CONSTRAINT [df_blog_users_userstate]  DEFAULT ((1)) FOR [userstate]
GO
/****** Object:  Default [df_blog_users_usercreatedate]    Script Date: 10/21/2013 16:09:00 ******/
ALTER TABLE [dbo].[blog_users] ADD  CONSTRAINT [df_blog_users_usercreatedate]  DEFAULT (getdate()) FOR [usercreatedate]
GO
/****** Object:  Default [df_blog_users_lastlogindate]    Script Date: 10/21/2013 16:09:00 ******/
ALTER TABLE [dbo].[blog_users] ADD  CONSTRAINT [df_blog_users_lastlogindate]  DEFAULT (getdate()) FOR [lastlogindate]
GO
/****** Object:  Default [df_blog_users_lastactivitydate]    Script Date: 10/21/2013 16:09:00 ******/
ALTER TABLE [dbo].[blog_users] ADD  CONSTRAINT [df_blog_users_lastactivitydate]  DEFAULT (getdate()) FOR [lastactivitydate]
GO
/****** Object:  Default [DF__blog_user__isSen__4AB81AF0]    Script Date: 10/21/2013 16:09:00 ******/
ALTER TABLE [dbo].[blog_userprofile] ADD  DEFAULT ((0)) FOR [isSendEmail]
GO
/****** Object:  ForeignKey [FK__blog_artic__artic__37A5467C]    Script Date: 10/21/2013 16:08:58 ******/
ALTER TABLE [dbo].[blog_articledetail]  WITH CHECK ADD  CONSTRAINT [FK__blog_artic__artic__37A5467C] FOREIGN KEY([articleid])
REFERENCES [dbo].[blog_article] ([id])
GO
ALTER TABLE [dbo].[blog_articledetail] CHECK CONSTRAINT [FK__blog_artic__artic__37A5467C]
GO
/****** Object:  ForeignKey [FK__blog_user__rolei__4E88ABD4]    Script Date: 10/21/2013 16:09:00 ******/
ALTER TABLE [dbo].[blog_users]  WITH CHECK ADD FOREIGN KEY([roleid])
REFERENCES [dbo].[blog_roles] ([roleid])
GO
/****** Object:  ForeignKey [FK__blog_user__useri__4D94879B]    Script Date: 10/21/2013 16:09:00 ******/
ALTER TABLE [dbo].[blog_userprofile]  WITH CHECK ADD FOREIGN KEY([userid])
REFERENCES [dbo].[blog_users] ([userid])
GO
