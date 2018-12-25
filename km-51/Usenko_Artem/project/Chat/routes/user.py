import os

from flask import Blueprint, redirect, session, request, send_from_directory
from flask.json import jsonify

from DB.Service import UserGetChats, AddNewChat, GetChatMessage, AddNewMessage, GetMessageUri, GetChatsByName, AddChat, \
    UpdateMessage, DeleteMessage, LeaveFromChat
from helpers.helpers import isUserInAlreadyLogin
from wtf.form.message import Message

user_api = Blueprint('user_api', __name__)
fileStorage = "D:\Chat"


@user_api.route("/user/chats")
def get_user_chats():
    if not isUserInAlreadyLogin(request):
        return redirect('/login')
    else:
        chats = UserGetChats(session.get("email"))
        return jsonify(chats)


@user_api.route("/user/new-chat/<chatName>")
def create_user_chats(chatName):
    if not isUserInAlreadyLogin(request):
        return redirect('/login')
    else:
        chats = AddNewChat(session.get("email"), chatName)
        return jsonify(chats)


@user_api.route("/user/chat-message/<int:chatId>")
def get_chat_message(chatId):
    if not isUserInAlreadyLogin(request):
        return redirect('/login')
    else:
        messages = GetChatMessage(chatId, session.get("email"))
        return jsonify(messages)


@user_api.route("/message/new/<int:chatid>", methods=["POST"])
def new_message(chatid):
    if not isUserInAlreadyLogin(request):
        return redirect('/login')
    else:
        form = Message()
        if not form.validate_on_submit():
            return redirect("/")
        url = None
        if (form.fileName.data):
            data = request.files[form.fileName.name].read()
            open(os.path.join('D:\Chat', form.fileName.data.filename), 'wb').write(data)
            url = os.path.join('D:\Chat', form.fileName.data.filename)

        AddNewMessage(form.message.data, url, chatid, session.get("email"))
        return redirect('/')


@user_api.route("/get/file/<messageid>")
def get_file(messageid):
    if not isUserInAlreadyLogin(request):
        return redirect('/login')
    else:
        uri = GetMessageUri(messageid)[0][0]
        paths = uri.split("\\")
        fileName = paths[-1]
        return send_from_directory(fileStorage, fileName)


@user_api.route("/find/chats/<name>")
def get_chats_by_name(name):
    if not isUserInAlreadyLogin(request):
        return redirect('/login')
    else:
        chats = GetChatsByName(name)
        return jsonify(chats)


@user_api.route("/add/chat/<int:chatid>")
def add_chat(chatid):
    if not isUserInAlreadyLogin(request):
        return redirect('/login')
    else:
        AddChat(chatid, session.get("email"))
        return redirect('/')


@user_api.route("/message/update/<int:messageid>/<messageText>")
def updateMessage(messageid, messageText):
    UpdateMessage(messageid, messageText)
    return redirect('/')


@user_api.route("/message/delete/<int:messageid>")
def deleteMessage(messageid):
    DeleteMessage(messageid)
    return redirect('/')


@user_api.route("/user/leave/<int:chatid>")
def leaveFromChat(chatid):
    LeaveFromChat(chatid, session.get("email"))
    return redirect('/')
