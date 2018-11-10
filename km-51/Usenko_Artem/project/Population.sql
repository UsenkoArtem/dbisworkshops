
Insert INTO chat(chat_id,chat_name) VALUES (Chat_seq.nextval, 'Chat1');
Insert INTO chat(chat_id,chat_name) VALUES (Chat_seq.nextval, 'Chat2');
Insert INTO chat(chat_id,chat_name) VALUES (Chat_seq.nextval, 'Chat3');
Insert INTO chat(chat_id,chat_name) VALUES (Chat_seq.nextval, 'Chat4');
Insert INTO chat(chat_id,chat_name) VALUES (Chat_seq.nextval, 'Chat5');



Insert Into ChatSettings(chat_settings_id, chat_id, chat_settings_information, chat_settings_administrator_id)
VALUES(ChatSettings_seq.nextval,
       (Select Chat.chat_id from Chat  where Chat.chat_name = 'Chat1'),
       (''),
       (Select "User".user_id from "User" where "User".USER_EMAIL = 'usenko@gmail.com'));

Insert Into ChatSettings(chat_settings_id, chat_id, chat_settings_information, chat_settings_administrator_id)
VALUES(ChatSettings_seq.nextval,
       (Select Chat.chat_id from Chat  where Chat.chat_name = 'Chat2'),
       (''),
       (Select "User".user_id from "User" where "User".USER_EMAIL = 'usenko2@gmail.com'));

Insert Into ChatSettings(chat_settings_id, chat_id, chat_settings_information, chat_settings_administrator_id)
VALUES(ChatSettings_seq.nextval,
       (Select Chat.chat_id from Chat  where Chat.chat_name = 'Chat3'),
       (''),
       (Select "User".user_id from "User" where "User".USER_EMAIL = 'usenko@gmail.com'));

Insert Into ChatSettings(chat_settings_id, chat_id, chat_settings_information, chat_settings_administrator_id)
VALUES(ChatSettings_seq.nextval,
       (Select Chat.chat_id from Chat  where Chat.chat_name = 'Chat4'),
       (''),
       (Select "User".user_id from "User" where "User".USER_EMAIL = 'usenko1@gmail.com'));



Insert Into Message(message_id, chat_id, message_text, message_date, message_owner)
VALUES(Message_seq.nextval,
       (Select Chat.chat_id from Chat  where Chat.chat_name = 'Chat1'),
       ('Lab4'),
       (SELECT SYSTIMESTAMP FROM dual),
       (Select "User".user_id from "User" where "User".USER_EMAIL = 'usenko1@gmail.com'));

Insert Into Message(message_id, chat_id, message_text, message_date, message_owner)
VALUES(Message_seq.nextval,
       (Select Chat.chat_id from Chat  where Chat.chat_name = 'Chat2'),
       'Lab5',
       (SELECT SYSTIMESTAMP FROM dual),
       (Select "User".user_id from "User" where "User".USER_EMAIL = 'usenko1@gmail.com'));

Insert Into Message(message_id, chat_id, message_text, message_date, message_owner)
VALUES(Message_seq.nextval,
       (Select Chat.chat_id from Chat  where Chat.chat_name = 'Chat3'),
       'Lab5',
       (SELECT SYSTIMESTAMP FROM dual),
       (Select "User".user_id from "User" where "User".USER_EMAIL = 'usenko1@gmail.com'));

Insert Into Message(message_id, chat_id, message_text, message_date, message_owner)
VALUES(Message_seq.nextval,
       (Select Chat.chat_id from Chat  where Chat.chat_name = 'Chat4'),
       'Lab4',
       (SELECT SYSTIMESTAMP FROM dual),
       (Select "User".user_id from "User" where "User".USER_EMAIL = 'usenko2@gmail.com'));



Insert INTO "User"(user_id, user_first_name, user_second_name, user_password, user_email) 
 VALUES (User_seq.nextval,
         'Artem',
         'Usenko',
         'Pass1',
         'usenko@gmail.com');

Insert INTO  "User"(user_id, user_first_name, user_second_name, user_password, user_email) 
 VALUES (User_seq.nextval,
         'Artem',
         'Usenko',
         'Pass2',
         'usenko1@gmail.com');

Insert INTO  "User"(user_id, user_first_name, user_second_name, user_password, user_email) 
 VALUES (User_seq.nextval,
         'Artem',
         'Usenko',
         'Pass3',
         'usenko2@gmail.com');
         
Insert INTO  "User"(user_id, user_first_name, user_second_name, user_password, user_email) 
 VALUES (User_seq.nextval,
         'Artem',
         'Usenko',
         'Pass4',
         'usenk3@gmail.com');


Insert INTO  UserSettings(user_settings_id, user_id, user_settings_position_on_job, user_settings_information) 
 VALUES (UserSettings_seq.nextval,
         (Select "User".user_id from "User" where "User".USER_EMAIL = 'usenko@gmail.com'),
         'student',
         'age 20');

Insert INTO  UserSettings(user_settings_id, user_id, user_settings_position_on_job, user_settings_information) 
 VALUES (UserSettings_seq.nextval,
         (Select "User".user_id from "User" where "User".USER_EMAIL = 'usenko1@gmail.com'),
         'student',
         'age 20');

Insert INTO  UserSettings(user_settings_id, user_id, user_settings_position_on_job, user_settings_information) 
 VALUES (UserSettings_seq.nextval,
         (Select "User".user_id from "User" where "User".USER_EMAIL = 'usenko2@gmail.com'),
         'student',
         'age 20');

Insert INTO  UserSettings(user_settings_id, user_id, user_settings_position_on_job, user_settings_information) 
 VALUES (UserSettings_seq.nextval,
         (Select "User".user_id from "User" where "User".USER_EMAIL = 'usenko3@gmail.com'),
         'student',
         'age 20');
