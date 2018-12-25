from datetime import datetime

import numpy as np
import plotly as plotly
import plotly.graph_objs as go

from flask import render_template, request, make_response, session, redirect, url_for, Blueprint, json

from DB.Service import IsUserInDB, AddNewUser, UserGetChats, GetMessageActivity, GetUserInChatsCount
from helpers.helpers import isUserInAlreadyLogin, createResponse
from wtf.form.login import LoginForm
from wtf.form.message import Message
from wtf.form.user import UserForm

index_api = Blueprint('index_api', __name__)
start_time = "2018.12.24"


@index_api.route("/")
def index():
    if not isUserInAlreadyLogin(request):
        return redirect('/login')
    else:
        form = Message()
        return render_template('index.html', form=form)


@index_api.route("/auth", methods=["GET", "POST"])
def auth():
    if isUserInAlreadyLogin(request):
        return redirect('/')

    form = UserForm()
    if request.method == "GET":
        return render_template('Registration.html', form=form)

    if request.method == "POST":
        if not form.validate_on_submit():
            return render_template('Registration.html', form=form)
        else:

            email = request.form["email"]
            password = request.form["password"]
            firstname = request.form["firstName"]
            secondname = request.form["secondName"]

            if not AddNewUser(firstname, secondname, email, password):
                return render_template('Registration.html', form=form)

            response = createResponse(request)
            session['email'] = email

            return response


@index_api.route("/login", methods=["POST", "GET"])
def login():
    if isUserInAlreadyLogin(request):
        return redirect('/')

    form = LoginForm()

    if request.method == "GET":
        return render_template('login.html', form=form)

    if request.method == "POST":
        if not form.validate_on_submit():
            return render_template('login.html', form=form)
        else:
            email = request.form["email"]
            password = request.form["password"]

            if not IsUserInDB(email, password):
                return render_template('login.html', form=form)

            response = createResponse(request)
            session['email'] = email

            return response


@index_api.route("/logout")
def logout():
    session.pop('email', None)
    response = make_response(redirect('/'))
    response.set_cookie("email", '', expires=0)
    return response


@index_api.route('/graphs', methods=['GET'])
def graphs():
    messageActivity = GetMessageActivity()
    x = list()
    y = list()
    for message in messageActivity:
        start = _datetime(start_time)
        end = _datetime(message[0])
        delta = (end - start).days
        x.append(delta)
        y.append(message[1])

    line = go.Scatter(
        x=x,
        y=y,
        name="sin(x)"
    )

    x = []
    y = []

    chats = GetUserInChatsCount()
    for chat in chats:
        x.append(chat[0])
        y.append(chat[1])

    bar = go.Bar(
        x=x,
        y=y
    )
    data = [line, bar]
    ids = [1, 2]

    graphJSON = json.dumps(data, cls=plotly.utils.PlotlyJSONEncoder)

    return render_template('graphs.html',
                           graphJSON=graphJSON, ids=ids)


def _datetime(date_str):
    format_str = '%Y.%m.%d'
    datetime_obj = datetime.strptime(date_str, format_str)
    return datetime_obj
