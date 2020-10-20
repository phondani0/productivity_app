from flask import Flask
from marshmallow import Schema, fields, pre_load, validate
from flask_marshmallow import Marshmallow
from flask_sqlalchemy import SQLAlchemy


ma = Marshmallow()
db = SQLAlchemy()


class TaskModel(db.Model):
    __tablename__ = 'tasks'

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(150), nullable=False)
    completed = db.Column(db.Boolean, nullable=False)
    user_id = db.Column(db.String(150), nullable=False)

    def __init__(self, title,  user_id, completed):
        self.title = title
        self.completed = completed
        self.user_id = user_id

    def serialize(self):
        print(self)
        return {
            "id": self.id,
            "title": self.title,
            "user_id": self.user_id,
            "completed": self.completed
        }


class TaskSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = TaskModel

    id = ma.auto_field()
    title = ma.auto_field()
    completed = ma.auto_field()
    user_id = ma.auto_field()
