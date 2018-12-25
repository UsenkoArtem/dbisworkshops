from flask_wtf import FlaskForm

from wtforms import StringField, SubmitField, validators


class LoginForm(FlaskForm):
    email = StringField("Email :", [validators.DataRequired("Required"), validators.email("Error in email")])
    password = StringField("Password :", [validators.DataRequired("Required")])

    submit = SubmitField("Sign in")
