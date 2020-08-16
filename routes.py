import os
import mysql.connector
from mysql.connector import Error
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from flask import Flask, render_template, flash, request, redirect, url_for, make_response, jsonify
from flask_wtf import FlaskForm
from flask_wtf.file import FileField, FileRequired, FileAllowed
from wtforms import SubmitField
from datetime import datetime
from werkzeug.utils import secure_filename
from werkzeug.datastructures import  FileStorage
from models import *
import requests

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI']='mysql+mysqldb://root:root@localhost/sancho_limitada'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS']=False
app.config['UPLOAD_FOLDER']=r'\Users\jdpa3\FlaskWebApp\static\img\uploads'
app.config['ALLOWED_IMAGE_EXTENSIONS']=['PNG, JPG, JPEG']

db = SQLAlchemy(app)
ma = Marshmallow(app)

basedir = os.path.abspath(os.path.dirname(__file__))

def allowed_image(filename):

    if not "." in filename:
        return False

    ext = filename.rsplit(".", 1)[1]

    if ext.upper() in app.config['ALLOWED_IMAGE_EXTENSIONS']:
        return True
    else:
        return False


# Index section
@app.route("/")
def main():

    all_products = Product.query.all()
    result = products_schema.dump(all_products)

    return render_template('index.html')

# User Registry section
@app.route("/signup", methods=['GET', 'POST'])
def showSignUp():

    if request.method == "POST":
        connection = db.engine.raw_connection()
            
        _id_type = request.form['id_type']
        _id_number = request.form['id_number']
        _user_name = request.form['user_name']
        _user_lastName = request.form['user_lastname']
        _user_email = request.form['user_email']
        _user_password = request.form['user_password']
        _user_address = request.form['user_address']
        _user_phone = request.form['user_phone']
        _user_picture = request.files['user_picture']
        _user_picture.save(os.path.join(app.config['UPLOAD_FOLDER'], _user_picture.filename))

        if _user_picture.filename == '':
            print("must have a filename")
        if not allowed_image(_user_picture):
            print("That image extension is not allowed")

        _registry_date = datetime.now()

        try:
            cursor = connection.cursor()
            cursor.callproc('sl_createuser', (_id_type, _id_number, _user_name, _user_lastName, _user_email, _user_password, _user_address, _user_phone, _user_picture, _registry_date))
            results = list(cursor.fetchall())
            cursor.close()
            connection.commit()
        finally:
            connection.close()

    return render_template('signup.html')

## Products section
@app.route("/products", methods=['GET', 'POST'])
def showProducts():

    if request.method == "POST":
        connection = db.engine.raw_connection()
        
        search = request.form.get("productSearch")
        cursor = connection.cursor()
        query = "select * from products where product_name LIKE '{}%'".format(search)
        
        cursor.execute(query)
        result = cursor.fetchall()

        if result:

            product_image = result[0][7]
            route_split = product_image.split()
            file_name = route_split[1].strip("\'")
                
            return render_template('products.html', product_name = result[0][3], product_code = result[0][1], product_price = result[0][4], product_image = file_name, product_status = result[0][6])
        else:
            return render_template('products.html', product_status = 0)
    else:
       return render_template('products.html')

@app.route("/productsDel", methods=['POST'])
def deleteProduct():   
    if request.method == "POST":
        connection = db.engine.raw_connection()
        search = request.form.get("product_name")
        result = [search]
        
        try:
            cursor = connection.cursor()
            cursor.callproc('deactivate_product', result)
            results = list(cursor.fetchall())
            cursor.close()
            connection.commit()
        finally:
            connection.close()

    return render_template('products.html', product_status = 0)


@app.route("/productReg", methods=['GET', 'POST'])
def productReg():

    if request.method == "POST":
        connection = db.engine.raw_connection()

        _productName = request.form['inputName']
        _code = request.form['inputCode']
        _category = request.form['inputCategory']
        _price = request.form['inputPrice']
        _quantity = request.form['inputQuantity']
        _status = '1'
        _product_picture = request.files['product_picture']
        _product_picture.save(os.path.join(app.config['UPLOAD_FOLDER'], _product_picture.filename))

        if _product_picture.filename == '':
            print("must have a filename")
        if not allowed_image(_product_picture):
            print("That image extension is not allowed")

        try:
            cursor = connection.cursor()
            cursor.callproc('sl_createproduct', (_productName, _code, _category, _price, _quantity, _status, _product_picture))
            results = list(cursor.fetchall())
            cursor.close()
            connection.commit()
        finally:
            connection.close()

    return render_template('product_registry.html')


# Billing section
@app.route("/billing", methods=['GET', 'POST'])
def showBilling():

    if request.method == "POST":
        connection = db.engine.raw_connection()
        
        search = request.form.get("inputCode2")
        cursor = connection.cursor()
        query = "select * from billing where billing_code LIKE '{}%'".format(search)
        
        cursor.execute(query)
        result = cursor.fetchall()

        return render_template('billing.html',billing_id = result[0][0], billing_code = result[0][1], billing_user = result[0][2], billing_products = result[0][3], billing_date = result[0][4], products_quantity = result[0][5], billing_totalvalue = result[0][6], billing_paymentmethod = result[0][7])
    else:
        return render_template('billing.html')

    return render_template('billing.html')

@app.route("/billingRequest", methods=['GET', 'POST'])
def requestBilling():

    if request.method == "POST":
        connection = db.engine.raw_connection()

        _billing_code = request.form['inputCode1']
        _client = request.form['inputClient']
        _products = request.form['inputProducts']
        _quantity = request.form['inputQuantity']
        _date = request.form['inputDate1']
        _total_value = request.form['inputTotal']
        _payment_method = request.form['inputPaymentMethod']

        try:
            cursor = connection.cursor()
            cursor.callproc('sl_createbilling', (_billing_code, _client, _products, _date, _quantity, _total_value, _payment_method))
            results = list(cursor.fetchall())
            cursor.close()
            connection.commit()
        finally:
            connection.close()

    return render_template('billing.html')

@app.route("/billingUpdate", methods=['GET', 'POST'])
def changeBilling():
    if request.method == "POST":
        connection = db.engine.raw_connection()

        _billing_id = request.form['billing_id']
        _billing_code = request.form['inputCode3']
        _client = request.form['inputUser2']
        _products = request.form['inputProducts2']
        _quantity = request.form['inputQuantity2']
        _date = request.form['inputDate2']
        _total_value = request.form['inputValue2']
        _payment_method = request.form['inputPayment2']

        try:
            cursor = connection.cursor()
            cursor.callproc('update_billing', (_billing_id, _billing_code, _client, _products, _date, _quantity, _total_value, _payment_method))
            results = list(cursor.fetchall())
            cursor.close()
            connection.commit()
        finally:
            connection.close()

    return render_template('billing.html')

#Clients Section
@app.route("/clients", methods=['GET', 'POST'])
def showClients():

    if request.method == "POST":
        connection = db.engine.raw_connection()
        
        search = request.form.get("userSearch")
        cursor = connection.cursor()
        query = "select * from users where user_name LIKE '{}%'".format(search)
        
        cursor.execute(query)
        result = cursor.fetchall()

        user_image = result[0][9]
        route_split = user_image.split()
        file_name = route_split[1].strip("\'")

        return render_template('clients.html',user_idnumber = result[0][2], user_name = result[0][3], user_lastname = result[0][4], user_email = result[0][5], user_phone = result[0][8], user_address = result[0][7], user_image = file_name)
    else:
       return render_template('clients.html')

@app.route("/usersDel", methods=['POST'])
def deleteUser():
    if request.method == "POST":
        connection = db.engine.raw_connection()
        search = request.form.get("user_name")
        result = [search]
        
        try:
            cursor = connection.cursor()
            cursor.callproc('deactivate_user', result)
            results = list(cursor.fetchall())
            cursor.close()
            connection.commit()
        finally:
            connection.close()

    return render_template('clients.html')


if __name__ == "__main__":
    app.run(debug=True)