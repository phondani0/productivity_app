from flask_restful import Resource
from middleware.auth import check_token
from Model import Task


class Task(Resource):

    def post(self):

        return {}

    @check_token
    def get(self):
        return {"id": "1", "title": "my special task", "completed": False}
