# app.py
from flask import Flask, request

app = Flask(__name__)

@app.route('/')
def index():
    return '''
        <form action="/calc">
            <input name="a" type="number">
            <select name="op">
                <option value="+">+</option>
                <option value="-">-</option>
            </select>
            <input name="b" type="number">
            <input type="submit">
        </form>
    '''

@app.route('/calc')
def calc():
    a = int(request.args.get('a', 0))
    b = int(request.args.get('b', 0))
    op = request.args.get('op')
    if op == '+':
        return f"{a} + {b} = {a + b}"
    elif op == '-':
        return f"{a} - {b} = {a - b}"
    return "Invalid operator"
