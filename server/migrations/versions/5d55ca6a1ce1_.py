"""empty message

Revision ID: 5d55ca6a1ce1
Revises: 0caf7d19eec3
Create Date: 2020-10-03 21:12:24.975272

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '5d55ca6a1ce1'
down_revision = '0caf7d19eec3'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('tasks', sa.Column('user_id', sa.String(length=150), nullable=False))
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('tasks', 'user_id')
    # ### end Alembic commands ###
