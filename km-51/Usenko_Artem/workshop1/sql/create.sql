/*==============================================================*/
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     03.11.2018 18:34:55                          */
/*==============================================================*/


alter table ChatSettings
   drop constraint FK_CHATSETTING_CHAT;

alter table Message
   drop constraint FK_MESSAGE_CHAT;

alter table UserSettings
   drop constraint FK_USERSETTINGS_USER;

alter table User_Chat
   drop constraint FK_CHAT_USER;

alter table User_Chat
   drop constraint FK_USER_CHAT;

drop table Chat cascade constraints;

drop index Chat_settings_FK;

drop table ChatSettings cascade constraints;

drop index Chat_messages_FK;

drop table Message cascade constraints;

drop table "User" cascade constraints;

drop index User_settings_FK;

drop table UserSettings cascade constraints;

drop index Chat_have_Users_FK;

drop index User_have_chats_FK;

drop table User_Chat cascade constraints;

/*==============================================================*/
/* Table: Chat                                                  */
/*==============================================================*/
create table Chat 
(
   Chat_id              INTEGER              not null,
   Chat_name            VARCHAR2(100),
   Chat_user_count      INTEGER DEFAULT 0,
   Chat_message_count   INTEGER DEFAULT 0,
   constraint PK_CHAT primary key (Chat_id)
);

CREATE SEQUENCE Chat_seq
  START WITH 1
  INCREMENT BY 1;



/*==============================================================*/
/* Table: ChatSettings                                          */
/*==============================================================*/
create table ChatSettings 
(
   chat_settings_id    INTEGER              not null,
   Chat_id             INTEGER              not null,
   chat_settings_information VARCHAR2(100),
   chat_settings_administrator_id INTEGER,
   constraint PK_CHATSETTINGS primary key (chat_settings_id)
);

CREATE SEQUENCE ChatSettings_seq
  START WITH 1
  INCREMENT BY 1;


/*==============================================================*/
/* Index: Chat_settings_FK                                      */
/*==============================================================*/
create index Chat_settings_FK on ChatSettings (
   Chat_id ASC
);

/*==============================================================*/
/* Table: Message                                               */
/*==============================================================*/
create table Message 
(
   message_id           INTEGER              not null,
   Chat_id              INTEGER              not null,
   message_text         CLOB,
   message_date         TIMESTAMP,
   message_file_url     CLOB DEFAULT '',
   message_owner        INTEGER              not null,
   constraint PK_MESSAGE primary key (message_id)
);

CREATE SEQUENCE Message_seq
  START WITH 1
  INCREMENT BY 1;

/*==============================================================*/
/* Index: Chat_messages_FK                                      */
/*==============================================================*/
create index Chat_messages_FK on Message (
   Chat_id ASC
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
   user_email           VARCHAR2(50) UNIQUE,
   constraint PK_USER primary key (user_id)
);

Alter Table "User" ADD CONSTRAINT user_first_name_check CHECK (REGEXP_LIKE(user_first_name, '^[A-Z]{1,1}[a-z]{0,39}$'));
Alter Table "User" ADD CONSTRAINT user_second_name_check CHECK (REGEXP_LIKE(user_second_name, '^[A-Z]{1,1}[a-z]{0,39}$'));
Alter Table "User" ADD CONSTRAINT user_email_check CHECK (REGEXP_LIKE(user_email, '^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'));

CREATE SEQUENCE User_seq
  START WITH 1
  INCREMENT BY 1;

ALTER TABLE ChatSettings ADD CONSTRAINT chat_administrator_fk FOREIGN KEY (chat_settings_administrator_id) REFERENCES "User" (user_id);
ALTER TABLE Message ADD CONSTRAINT message_owner_fk FOREIGN KEY (message_owner) REFERENCES "User" (user_id);
ALTER TABLE Message ADD CONSTRAINT chat_id_fk FOREIGN KEY (chat_id) REFERENCES Chat(chat_id);

/*==============================================================*/
/* Table: UserSettings                                          */
/*==============================================================*/
create table UserSettings 
(
   user_settings_id     INTEGER              not null,
   user_id              INTEGER,
   user_settings_notification VARCHAR2(100) DEFAULT '',
   user_settings_position_on_job VARCHAR2(100),
   user_settings_information VARCHAR2(100),
   constraint PK_USERSETTINGS primary key (user_settings_id)
);

Alter Table UserSettings ADD CONSTRAINT user_settings_position_on_job_check CHECK (REGEXP_LIKE(user_second_name, '^[a-zA-Z]{1,100}$'));

CREATE SEQUENCE UserSettings_seq
  START WITH 1
  INCREMENT BY 1;


/*==============================================================*/
/* Index: User_settings_FK                                      */
/*==============================================================*/
create index User_settings_FK on UserSettings (
   user_id ASC
);

/*==============================================================*/
/* Table: User_Chat                                             */
/*==============================================================*/
create table User_Chat 
(
   Chat_id              INTEGER              not null,
   user_id              INTEGER              not null,
   constraint PK_USER_CHAT primary key (Chat_id, user_id)
);

/*==============================================================*/
/* Index: User_have_chats_FK                                    */
/*==============================================================*/
create index User_have_chats_FK on User_Chat (
   user_id ASC
);

/*==============================================================*/
/* Index: Chat_have_Users_FK                                    */
/*==============================================================*/
create index Chat_have_Users_FK on User_Chat (
   Chat_id ASC
);

alter table ChatSettings
   add constraint FK_CHATSETTING_CHAT foreign key (Chat_id)
      references Chat (Chat_id);

alter table Message
   add constraint FK_MESSAGE_CHAT foreign key (Chat_id)
      references Chat (Chat_id);

alter table UserSettings
   add constraint FK_USERSETTINGS_USER foreign key (user_id)
      references "User" (user_id);

alter table User_Chat
   add constraint FK_CHAT_USER foreign key (Chat_id)
      references Chat (Chat_id);

alter table User_Chat
   add constraint FK_USER_CHAT foreign key (user_id)
      references "User" (user_id);
