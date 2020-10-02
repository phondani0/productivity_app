from flask import Flask
import firebase_admin
import os
from firebase_admin import credentials
from model import db
from app import api_bp


def create_app(config_filename):
    app = Flask(__name__)
    app.config.from_object(config_filename)

    app.register_blueprint(api_bp, url_prefix='/api')

    db.init_app(app)

    if not firebase_admin._apps:
        THIS_FOLDER = os.path.dirname(os.path.abspath(__file__))
        firebase_admin_config = os.path.join(
            THIS_FOLDER, 'firebase-admin.json')
        # Connect to firebase
        cred = credentials.Certificate(firebase_admin_config)
        firebase_admin.initialize_app(cred)

    return app


app = create_app("config")

if __name__ == "__main__":
    app.run(debug=True)
