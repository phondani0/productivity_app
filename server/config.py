from sqlalchemy.engine import create_engine
import urllib
import os


# engine = create_engine('mssql+pymysql:///?odbc_connect=' +
#                        urllib.parse.quote_plus(
#                            'DRIVER=FreeTDS;SERVER=<IP_OR_HOSTNAME>;PORT=1433;DATABASE=<DATABASE_NAME>;UID=<USERNAME>;PWD=<PASSWORD>;TDS_Version=8.0;')
#  )

engine = create_engine(
    'mysql+pymysql://ankit:%s@localhost:3306/productivity_app' % urllib.parse.quote_plus('<your_mysql_password>'))

SQLALCHEMY_ECHO = False
SQLALCHEMY_TRACK_MODIFICATIONS = True
SQLALCHEMY_DATABASE_URI = engine.url
