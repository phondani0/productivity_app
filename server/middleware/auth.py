from functools import wraps
from flask import request
from firebase_admin import auth


def check_token(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        print(request.headers)
        if not request.headers.get('Authorization'):
            return {'message': 'No token provided'}, 400
        try:
            user = auth.verify_id_token(request.headers['Authorization'])
            # print(user)
            request.user = user
        except:
            return {'message': 'Invalid token provided.'}, 400
        return f(*args, **kwargs)
    return wrap
