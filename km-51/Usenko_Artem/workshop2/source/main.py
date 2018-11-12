# -*- coding: utf-8 -*-

from flask import Flask, render_template, request, redirect, url_for

"""
Напсать страницы для талиц Message, ChatSettings
"""

app = Flask(__name__)

@app.route('/api/<action>', methods=['GET'])
def action(action):
    if action == "chatSettings":
        return render_template("chatSettings.html", chatSettings=ChatSettings)

    elif action == "message":
        return render_template("message.html", message=Message)

    elif action == "all":
        return render_template("all.html", chatSettings=ChatSettings, message=Message)

    else:
        return render_template("404.html", action_value=action, avaible=["message", "chatSettings"])


@app.route('/api', methods=['POST'])
def editDictionary():
    if request.form["action"] == "chat_settings_update":
        ChatSettings["id"] = request.form["id"]
        ChatSettings["chatId"] = request.form["chatId"]
        ChatSettings["chatSettingsInformation"] = request.form["chatSettingsInformation"]
        ChatSettings["chatSettingsAdministratorId"] = request.form["chatSettingsAdministratorId"]

    if request.form["action"] == "message_update":
        Message["id"] = request.form["id"]
        Message["chatId"] = request.form["chatId"]
        Message["messageText"] = request.form["messageText"]
        Message["message_date"] = request.form["message_date"]
        Message["messageOwner"] = request.form["messageOwner"]

    return redirect(url_for('action', action="all"))


if __name__ == '__main__':
    app.run(port=8080)

ChatSettings = {'id': "301301",
                'chatId': "301",
                'chatSettingsInformation': "all notification",
                'chatSettingsAdministratorId': "1"}

Message = {'id': "301",
           'chatId': "301",
           'messageText': "hello users",
           'message_date': '12.11.2018',
           'messageOwner': "123"}
