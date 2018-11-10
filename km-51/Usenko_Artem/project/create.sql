/*==============================================================*/
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     10.11.2018 17:44:59                          */
/*==============================================================*/


alter table ChatSettings
   drop constraint FK_CHAT_SETTINGS;

alter table Message
   drop constraint FK_CHAT_MESSAGE;

alter table Message
   drop constraint FK_USER_MESSAGE;

alter table UserSettings
   drop constraint FK_USERSETT_USER_SETT_USER;

alter table User_chat_admin
   drop constraint FK_CHAT_ADMIN;

alter table User_chat_admin
   drop constraint FK_USER_ADMIN_CHAT;

alter table User_have_chat
   drop constraint FK_CHAT_USER;

alter table User_have_chat
   drop constraint FK_USER_CHAT;

drop table Chat cascade constraints;

drop table ChatSettings cascade constraints;

drop index User_message_FK;

drop index Chat_messages_FK;

drop table Message cascade constraints;

drop table "User" cascade constraints;

drop index User_settings_FK;

drop table UserSettings cascade constraints;

drop index Chat_Admin_FK;

drop index User_chat_admin2_FK;

drop table User_chat_admin cascade constraints;

drop index Chat_User_FK;

drop index User_have_chat2_FK;

drop table User_have_chat cascade constraints;

/*==============================================================*/
/* Table: Chat                                                  */
/*==============================================================*/
create table Chat 
(
   Chat_id              INTEGER              not null,
   Chat_name            VARCHAR2(100)        not null,
   Chat_user_count      INTEGER,
   Chat_message_count   INTEGER,
   constraint PK_CHAT primary key (Chat_id)
);

/*==============================================================*/
/* Table: ChatSettings                                          */
/*==============================================================*/
create table ChatSettings 
(
   Chat_id              INTEGER              not null,
   chat_settings_information VARCHAR2(100),
   chat_settings_administrator_id INTEGER,
   chat_settings_id     INTEGER              not null,
   constraint PK_CHATSETTINGS primary key (Chat_id)
);

/*==============================================================*/
/* Table: Message                                               */
/*==============================================================*/
create table Message 
(
   message_id           INTEGER              not null,
   message_text         CLOB                 not null,
   message_date         DATE                 not null,
   Chat_id              INTEGER,
   user_id              INTEGER,
   message_file_url     CLOB,
   constraint PK_MESSAGE primary key (message_id)
);

/*==============================================================*/
/* Index: Chat_messages_FK                                      */
/*==============================================================*/
create index Chat_messages_FK on Message (
   Chat_id ASC
);

/*==============================================================*/
/* Index: User_message_FK                                       */
/*==============================================================*/
create index User_message_FK on Message (
   user_id ASC
);

/*==============================================================*/
/* Table: "User"                                                */
/*==============================================================*/
create table "User" 
(
   user_id              INTEGER              not null,
   user_first_name      VARCHAR2(40),
   user_second_name     VARCHAR2(40),
   user_password        VARCHAR2(40),
   user_email           VARCHAR2(50)         not null,
   constraint PK_USER primary key (user_id)
);

/*==============================================================*/
/* Table: UserSettings                                          */
/*==============================================================*/
create table UserSettings 
(
   user_settings_id     INTEGER              not null,
   user_id              INTEGER,
   user_settings_notification VARCHAR2(100),
   user_settings_position_on_job VARCHAR2(100),
   user_settings_information VARCHAR2(100),
   constraint PK_USERSETTINGS primary key (user_settings_id)
);

/*==============================================================*/
/* Index: User_settings_FK                                      */
/*==============================================================*/
create index User_settings_FK on UserSettings (
   user_id ASC
);

/*==============================================================*/
/* Table: User_chat_admin                                       */
/*==============================================================*/
create table User_chat_admin 
(
   Chat_id              INTEGER              not null,
   user_id              INTEGER              not null,
   constraint PK_USER_CHAT_ADMIN primary key (Chat_id, user_id)
);

/*==============================================================*/
/* Index: User_chat_admin2_FK                                   */
/*==============================================================*/
create index User_chat_admin2_FK on User_chat_admin (
   user_id ASC
);

/*==============================================================*/
/* Index: Chat_Admin_FK                                         */
/*==============================================================*/
create index Chat_Admin_FK on User_chat_admin (
   Chat_id ASC
);

/*==============================================================*/
/* Table: User_have_chat                                        */
/*==============================================================*/
create table User_have_chat 
(
   Chat_id              INTEGER              not null,
   user_id              INTEGER              not null,
   constraint PK_USER_HAVE_CHAT primary key (Chat_id, user_id)
);

/*==============================================================*/
/* Index: User_have_chat2_FK                                    */
/*==============================================================*/
create index User_have_chat2_FK on User_have_chat (
   user_id ASC
);

/*==============================================================*/
/* Index: Chat_User_FK                                          */
/*==============================================================*/
create index Chat_User_FK on User_have_chat (
   Chat_id ASC
);

alter table ChatSettings
   add constraint FK_CHAT_SETTINGS foreign key (Chat_id)
      references Chat (Chat_id);

alter table Message
   add constraint FK_CHAT_MESSAGE foreign key (Chat_id)
      references Chat (Chat_id);

alter table Message
   add constraint FK_USER_MESSAGE foreign key (user_id)
      references "User" (user_id);

alter table UserSettings
   add constraint FK_USERSETT_USER_SETT_USER foreign key (user_id)
      references "User" (user_id);

alter table User_chat_admin
   add constraint FK_CHAT_ADMIN foreign key (Chat_id)
      references ChatSettings (Chat_id);

alter table User_chat_admin
   add constraint FK_USER_ADMIN_CHAT foreign key (user_id)
      references "User" (user_id);

alter table User_have_chat
   add constraint FK_CHAT_USER foreign key (Chat_id)
      references Chat (Chat_id);

alter table User_have_chat
   add constraint FK_USER_CHAT foreign key (user_id)
      references "User" (user_id);

