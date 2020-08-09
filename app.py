import os
import logging
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask.logging import create_logger
from sqlalchemy import text
from sqlalchemy.exc import ResourceClosedError
from googletrans import Translator


app = Flask(__name__)
LOG = create_logger(app)
LOG.setLevel(logging.INFO)

db_user = os.environ.get('POSTGRES_DB_USER') or 'root'
db_password = os.environ.get('POSTGRES_DB_PASSWORD') or 'password'
db_host = os.environ.get('POSTGRES_SERVICE_HOST') or 'my_postgres'


app.config['SQLALCHEMY_DATABASE_URI'] = f'postgres://{db_user}:{db_password}@{db_host}:5432/postgres'
print(app.config['SQLALCHEMY_DATABASE_URI'])
db = SQLAlchemy(app)


@app.route("/")
def home():
    html = "<h3>Translate App</h3>"
    return html


@app.route("/translate", methods=['POST'])
def translate():
    """
    Post a translation query and store the following fields in translate db
    Use the database before using translation service
    """

    # Logging the input payload
    json_payload = request.json
    my_word = json_payload['word']
    LOG.info("Word to be translated: \n%s" % my_word)

    sql = f"select * from translation.translator where origin='{my_word}';"
    result = db.engine.execute(sql)
    result = result.fetchall()
    if len(result) > 0:
        LOG.info("Results: \n%s" % result)
        json_result = [{column: value for column, value in rowproxy.items()}
                       for rowproxy in result]
    else:
        json_result = dict()
        json_result["translated_from"] = "google_api"
        translator = Translator()
        result = translator.translate(my_word)
        json_result["origin"] = my_word
        json_result["origin_language"] = result.src
        json_result["translation"] = result.text
        json_result["translation_language"] = result.dest
        sql_statement = f"insert into translation.translator(origin, origin_language, translation, translation_language) values('{my_word}', '{json_result['origin_language']}','{json_result['translation']}', '{json_result['translation_language']}')"
        result = db.engine.execute(sql_statement)

    db.session.commit()

    return jsonify({'result': json_result})


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True)  # specify port=80
