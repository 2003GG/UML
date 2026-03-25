CREATE DATABASE  UML_bibliothèque;
use  UML_bibliothèque;
CREATE Table Users(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    email VARCHAR(30)
)

CREATE TABLE Emprunts(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    date_debut DATE,
    date_retour_prévue DATE,
    date_retour_effective DATE,
    livre_id INTEGER,
    Foreign Key (livre_id) REFERENCES Livres(id)
)

CREATE TABLE Livres(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(15),
    author VARCHAR(20),
    description VARCHAR(200),
    category_id INTEGER,
    Foreign Key (category_id) REFERENCES Categorys(id)
)

 CREATE TABLE Categorys(
    id integer PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(90)
 )

 DROP DATABASE bibliothèque