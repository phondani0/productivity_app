from flask import request
from flask_restful import Resource
from middleware.auth import check_token
from model import Task


class Task(Resource):

    def post(self):
        print(request)
        return {}

    # @check_token
    def get(self):

        return [
            {"id": "1", "title": "my special task 1", "completed": False},
            {"id": "1", "title": "my special task 2", "completed": False}
        ]
