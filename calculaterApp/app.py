from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/')
def home():
    return "Welcome to Calculator App!"

@app.route('/add')
def add():
    a = int(request.args.get("a"))
    b = int(request.args.get("b"))
    return jsonify(result=a + b)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
