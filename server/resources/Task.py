from flask import request
from flask_restful import Resource
from middleware.auth import check_token
from model import TaskModel, db
import time

class Task(Resource):

    @check_token
    def post(self):
        print(request.user)
        json_data = request.get_json(force=True)
        print(json_data)
        task = TaskModel(title=json_data['title'],
                         user_id=request.user['user_id'],
                         completed=False)
        db.session.add(task)
        db.session.commit()

        result = TaskModel.serialize(task)
        return {"status": 'success', 'data': result}

    @check_token
    def get(self):
        time.sleep(5)
        result = []
        tasks = TaskModel.query.filter_by(
            user_id=request.user['user_id']).all()
        for task in tasks:
            result.append(TaskModel.serialize(task))

        return result
