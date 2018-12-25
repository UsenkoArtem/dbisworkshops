from flask import Flask
from flask_wtf import CSRFProtect

from routes.index import index_api
from routes.user import user_api

app = Flask(__name__)
app.secret_key = "Development key"
app.register_blueprint(index_api)
app.register_blueprint(user_api)
csrf = CSRFProtect(app)
csrf.init_app(app)

app.run(debug=True)
