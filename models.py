from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from sqlalchemy import Column, Integer, String

app = Flask(__name__)

db = SQLAlchemy(app)
ma = Marshmallow(app)

class Product(db.Model):
    """Data model for product information."""

    __tablename__ = 'products'
    product_id = db.Column(
        db.Integer,
        primary_key=True
    )
    product_code = db.Column(
        db.Integer,
        index=False,
        unique=False,
        nullable=False
    )
    category = db.Column(
        db.Integer,
        index=False,
        unique=False,
        nullable=False
    )
    product_name = db.Column(
        String(45),
        index=False,
        unique=True,
        nullable=False
    )
    price = db.Column(
        db.Integer,
        index=False,
        unique=False,
        nullable=False
    )
    stored_quantity = db.Column(
        db.Integer,
        index=False,
        unique=False,
        nullable=False
    )
    product_status = db.Column(
        db.Integer,
        index=False,
        unique=False,
        nullable=False
    )
    product_image = db.Column(
        String(100),
        index=False,
        unique=True,
        nullable=False
    )

class User(db.Model):
    """Data model for user accounts."""

    __tablename__ = 'users'
    idusers = db.Column(
        db.Integer,
        primary_key=True
    )
    id_type = db.Column(
        db.Integer,
        index=False,
        unique=False,
        nullable=False
    )
    id_number = db.Column(
        db.Integer,
        index=False,
        unique=True,
        nullable=False
    )
    user_name = db.Column(
        String(45),
        index=False,
        unique=True,
        nullable=False
    )
    user_lastname = db.Column(
        String(45),
        index=False,
        unique=True,
        nullable=False
    )
    user_email = db.Column(
        String(100),
        index=True,
        unique=True,
        nullable=False
    )
    user_password = db.Column(
        String(100),
        index=False,
        unique=False,
        nullable=False
    )
    user_address = db.Column(
        String(45),
        index=False,
        unique=False,
        nullable=False
    )
    user_phone = db.Column(
        String(45),
        index=False,
        unique=True,
        nullable=False
    )
    user_picture = db.Column(
        String(100),
        index=False,
        unique=True,
        nullable=True
    )
    registry_date = db.Column(
        String(45),
        index=False,
        unique=False,
        nullable=True
    )

    def __init__(self, id_type, id_number, user_name, user_lastname, user_email, user_password, user_address, user_phone, user_picture):
        self.id_type = id_type
        self.id_number = id_number
        self.user_name = user_name
        self.user_lastname = user_lastname
        self.user_email = user_email
        self.user_password = user_password
        self.user_address = user_address
        self.user_phone = user_phone
        self.user_picture = user_picture

    def __repr__(self):
        return '<User {}>'.format(self.user_name)

db.create_all()

class ProductSchema(ma.Schema):
    class Meta:
        fields = ('id', 'product_id', 'product_code', 'category', 'product_name', 'price', 'stored_quantity', 'product_status', 'product_image')

product_schema = ProductSchema()
products_schema = ProductSchema(many=True)

class UserSchema(ma.Schema):
    class Meta:
        fields = ('id', 'id_type', 'id_number', 'user_name', 'user_lastname', 'user_email', 'user_password', 'user_address', 'user_phone', 'user_picture', 'registry_date')

user_schema = UserSchema()
users_schema = UserSchema(many=True)