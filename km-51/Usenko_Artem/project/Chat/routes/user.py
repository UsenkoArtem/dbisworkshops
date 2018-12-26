import os

from flask import Blueprint, redirect, session, request, send_from_directory, render_template
from flask.json import jsonify

from DB.Service import UserGetChats, AddNewChat, GetChatMessage, AddNewMessage, GetMessageUri, GetChatsByName, AddChat, \
    UpdateMessage, DeleteMessage, LeaveFromChat, UpdateFirstName, UpdateSecondName, UpdateEmail, UpdatePassword
from helpers.helpers import isUserInAlreadyLogin, createResponse
from wtf.form.message import Message
from wtf.form.user import UserForm

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
    if not isUserInAlreadyLogin(request):
        return redirect('/login')
    else:
        UpdateMessage(messageid, messageText)
    return redirect('/')


@user_api.route("/message/delete/<int:messageid>")
def deleteMessage(messageid):
    if not isUserInAlreadyLogin(request):
        return redirect('/login')
    else:
        DeleteMessage(messageid)
    return redirect('/')


@user_api.route("/user/leave/<int:chatid>")
def leaveFromChat(chatid):
    if not isUserInAlreadyLogin(request):
        return redirect('/login')
    else:
        LeaveFromChat(chatid, session.get("email"))
    return redirect('/')


@user_api.route("/user/update", methods=["POST"])
def updateUser():
    if not isUserInAlreadyLogin(request):
        return redirect('/login')
    else:
        form = Message()
        userForm = UserForm()
        if not userForm.validate_on_submit():
            return render_template('Index.html', form=form, userForm=userForm, errors="true")
        else:

            email = userForm.email.data
            password = userForm.password.data
            firstname = userForm.firstName.data
            secondname = userForm.secondName.data
            oldNewEmail = session.get("email")

            UpdateFirstName(firstname, oldNewEmail)
            UpdateSecondName(secondname, oldNewEmail)
            UpdatePassword(password, oldNewEmail)
            UpdateEmail(email, oldNewEmail)

        return createResponse(request)
