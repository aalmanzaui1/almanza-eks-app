import os
from flask import Flask, jsonify, request, send_from_directory
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/',methods=['GET'])
def get_ui():
    return send_from_directory('ui', 'almanzacn1.html')

@app.route('/container1',methods=['GET'])
def get_ui_container():
    return send_from_directory('ui', 'almanzacn1.html')

if __name__ == '__main__':
    from argparse import ArgumentParser
    parser = ArgumentParser()
    parser.add_argument('-p','--port', type=int, default=8080)
    args = parser.parse_args()
    port = args.port
    app.run(host='0.0.0.0',port=port)