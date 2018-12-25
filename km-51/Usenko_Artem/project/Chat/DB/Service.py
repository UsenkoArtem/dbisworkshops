import cx_Oracle

from DB.Oracle import Oracle


def IsUserInDB(email, password):
    connect = Oracle().connect('Course_4', 'art', 'localhost', 1521, 'XE')
    cursor = connect.cursor()
    dbResult = cursor.var(cx_Oracle.NUMBER)
    cursor.callfunc('user_package.login_user', dbResult, [str(email), str(password)])
    connect.close()
    return dbResult.values[0] == 0.0


def AddNewUser(firstName, secondName, email, password):
    connect = Oracle().connect('Course_4', 'art', 'DESKTOP-5UL0E3G', 1521, 'XE')
    cursor = connect.cursor()
    dbResult = cursor.var(cx_Oracle.NUMBER)
    cursor.callfunc('user_package.addUser', dbResult, [str(firstName), str(secondName), str(password), str(email)])
    cursor.close()
    connect.commit()
    connect.close()
    return dbResult.values[0] == 0.0


def UserGetChats(email):
    connect = Oracle().connect('Course_4', 'art', 'DESKTOP-5UL0E3G', 1521, 'XE')
    cursor = connect.cursor()
    query = 'select * from table(user_package.get_user_chats(:email))'
    cursor.execute(query, email=email)
    result = cursor.fetchall()
    cursor.close()
    connect.close()
    return result


def AddNewChat(email, chatName):
    connect = Oracle().connect('Course_4', 'art', 'DESKTOP-5UL0E3G', 1521, 'XE')
    cursor = connect.cursor()
    dbResult = cursor.var(cx_Oracle.NUMBER)
    cursor.callfunc('chat_package.add_chat', dbResult, [str(chatName), str(email)])
    cursor.close()
    connect.commit()
    connect.close()
    return dbResult.values[0] >= 0


def GetChatMessage(chatId, useremail):
    connect = Oracle().connect('Course_4', 'art', 'DESKTOP-5UL0E3G', 1521, 'XE')
    cursor = connect.cursor()
    query = 'select * from table(MESSAGE_PACKAGE.GET_MESSAGE(:chatId,:useremail))'
    cursor.execute(query, chatId=chatId, useremail=useremail)
    result = cursor.fetchall()
    cursor.close()
    connect.close()
    return result


def AddNewMessage(messageText, url, chatId, useremail):
    connect = Oracle().connect('Course_4', 'art', 'DESKTOP-5UL0E3G', 1521, 'XE')
    cursor = connect.cursor()
    dbResult = cursor.var(cx_Oracle.NUMBER)
    cursor.callfunc('MESSAGE_PACKAGE.ADD_MESSAGE', dbResult, [str(messageText), str(url), str(useremail), str(chatId)])
    cursor.close()
    connect.commit()
    connect.close()
    return dbResult.values[0] >= 0


def GetMessageUri(messageid):
    connect = Oracle().connect('Course_4', 'art', 'DESKTOP-5UL0E3G', 1521, 'XE')
    cursor = connect.cursor()
    query = 'select FILE_URL from (MESSAGE) where MESSAGE_ID = (:messageid) and  ISDELETE is null'
    cursor.execute(query, messageid=messageid)
    result = cursor.fetchall()
    cursor.close()
    connect.close()
    return result


def GetChatsByName(chatname):
    connect = Oracle().connect('Course_4', 'art', 'DESKTOP-5UL0E3G', 1521, 'XE')
    cursor = connect.cursor()
    query = 'select * from table(CHAT_PACKAGE.GET_CHATS_BY_NAME(:chatname))'
    cursor.execute(query, chatname=chatname)
    result = cursor.fetchall()
    cursor.close()
    connect.close()
    return result


def AddChat(chatid, useremail):
    connect = Oracle().connect('Course_4', 'art', 'DESKTOP-5UL0E3G', 1521, 'XE')
    cursor = connect.cursor()

    cursor.callproc('USER_PACKAGE.user_add_chat', [str(chatid), str(useremail)])
    cursor.close()
    connect.commit()
    connect.close()


def GetMessageActivity():
    connect = Oracle().connect('Course_4', 'art', 'DESKTOP-5UL0E3G', 1521, 'XE')
    cursor = connect.cursor()
    query = 'select to_char(MESSAGE_DATE, \'YYYY.MM.DD\') ,count(*) from MESSAGE_VIEW group by to_char(MESSAGE_DATE, \'YYYY.MM.DD\')'
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    connect.close()
    return result


def GetUserInChatsCount():
    connect = Oracle().connect('Course_4', 'art', 'DESKTOP-5UL0E3G', 1521, 'XE')
    cursor = connect.cursor()
    query = 'select to_char(CHAT_NAME) ,count(*) from CHAT_VIEW group by CHAT_NAME'
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    connect.close()
    return result


def UpdateMessage(messageid, messagetext):
    connect = Oracle().connect('Course_4', 'art', 'DESKTOP-5UL0E3G', 1521, 'XE')
    cursor = connect.cursor()
    cursor.callproc('message_package.message_update_text', [str(messageid), str(messagetext)])
    cursor.close()
    connect.commit()
    connect.close()


def DeleteMessage(messageid):
    connect = Oracle().connect('Course_4', 'art', 'DESKTOP-5UL0E3G', 1521, 'XE')
    cursor = connect.cursor()
    cursor.callproc('message_package.message_delete', [str(messageid)])
    cursor.close()
    connect.commit()
    connect.close()


def LeaveFromChat(chatId, userEmail):
    connect = Oracle().connect('Course_4', 'art', 'DESKTOP-5UL0E3G', 1521, 'XE')
    cursor = connect.cursor()
    cursor.callproc('user_package.user_leave_chat', [str(chatId), str(userEmail)])
    cursor.close()
    connect.commit()
    connect.close()
