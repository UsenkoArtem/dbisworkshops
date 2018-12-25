import datetime

from flask import session, make_response, redirect


def isUserInAlreadyLogin(request):
    if 'email' in session:
        return True
    else:
        email = request.cookies.get("email")
        if email is None:
            return False
        else:
            session['email'] = email
            return True


def createResponse(request):
    response = make_response(redirect('/'))
    expire_date = datetime.datetime.now() + datetime.timedelta(days=90)
    response.set_cookie("email", request.form["email"], expires=expire_date)
    return response
