from flask_restful import Resource


class Task(Resource):
    @check_token
    def get(self):
        return {"id": "1", "title": "my special task", "completed": False}
