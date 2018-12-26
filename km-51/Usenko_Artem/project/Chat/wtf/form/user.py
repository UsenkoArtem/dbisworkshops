from flask_wtf import Form
from wtforms import StringField, SubmitField, PasswordField, DateField
from wtforms import validators


class UserForm(Form):
    firstName = StringField("Name: ", [
        validators.DataRequired("Please enter your name."),
        validators.Length(3, 20, "Name should be from 3 to 40 symbols"),
        validators.regexp('^[A-Z][a-z]{0,39}$')
    ])

    secondName = StringField("Name: ", [
        validators.DataRequired("Please enter your suriname."),
        validators.Length(3, 20, "Name should be from 3 to 40 symbols"),
        validators.regexp('^[A-Z][a-z]{0,39}$')
    ])

    email = StringField("Email: ", [
        validators.DataRequired("Please enter your email."),
        validators.length(3, 50, "Email should be to 50 symbols"),
        validators.Email("Wrong email format")
    ])

    password = PasswordField("Password:", [
        validators.DataRequired("Please enter your password."),
        validators.Length(3, 10, "Password should be from 3 to 10 symbols")
    ])

    submit = SubmitField("Register")
