from flask_wtf import Form
from wtforms import FileField, StringField, validators, SubmitField


class Message(Form):
    message = StringField("message")
    fileName = FileField()
    submit = SubmitField("send")
