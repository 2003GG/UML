CREATE DATABASE Mon_livraison;
USE Mon_livraison;

CREATE Table Utilisateurs(
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(20),
    email VARCHAR(30),
    type enum('client','livreur'),
    created_at DATE
);

CREATE TABLE Commandes(
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    client_id INTEGER,
    livreur_id INTEGER,
    restaurant_id INTEGER,
    statut ENUM('livré', 'en cours', 'annulé'),
    total DECIMAL,
    created_at DATE,
    Foreign Key (client_id) REFERENCES Utilisateurs(id),
    Foreign Key (livreur_id) REFERENCES Utilisateurs(id),
    Foreign Key (restaurant_id) REFERENCES Restaurant(id)
);

CREATE TABLE Restaurant(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(20),
    ville VARCHAR(20),
    note_moy FLOAT
);

CREATE TABLE Plats(
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INTEGER,
    nom VARCHAR(20),
    prix DECIMAL,
    categorie VARCHAR(20)
);
CREATE TABLE Notaions(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    commande_id INTEGER,
    note INTEGER,
    commentaire TEXT
);

CREATE TABLE Lignes_commande(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    commande_id INTEGER,
    plat_id INTEGER,
    quantite INTEGER,
    prix_unit DECIMAL
);

-- Utilisateurs
INSERT INTO Utilisateurs (nom, email, type, created_at) VALUES
('Alice Martin', 'alice@mail.com', 'client', '2024-01-10'),
('Bob Dupont', 'bob@mail.com', 'client', '2024-02-15'),
('Clara Petit', 'clara@mail.com', 'client', '2024-03-05'),
('David Roux', 'david@mail.com', 'livreur', '2024-01-20'),
('Emma Blanc', 'emma@mail.com', 'livreur', '2024-02-28'),
('Fatima Saidi', 'fatima@mail.com', 'client', '2024-04-01'),
('Hugo Leroy', 'hugo@mail.com', 'livreur', '2024-03-18');

-- Restaurant (insert before Commandes due to FK)
INSERT INTO Restaurant (nom, ville, note_moy) VALUES
('Pizza Palace', 'Paris', 4.5),
('Burger King', 'Lyon', 4.1),
('Sushi Zen', 'Marseille', 4.7),
('Tacos House', 'Toulouse', 3.9),
('Le Bistrot', 'Paris', 4.3);

-- Commandes
INSERT INTO Commandes (client_id, livreur_id, restaurant_id, statut, total, created_at) VALUES
(1, 4, 1, 'livré',   28.50, '2024-05-01'),
(2, 5, 3, 'livré',   45.00, '2024-05-03'),
(3, 4, 2, 'en cours',19.99, '2024-05-10'),
(1, 7, 4, 'annulé',  12.00, '2024-05-12'),
(6, 5, 5, 'livré',   33.75, '2024-05-15'),
(2, 7, 1, 'en cours',22.00, '2024-05-18'),
(3, 4, 3, 'livré',   57.20, '2024-05-20');

-- Plats
INSERT INTO Plats (restaurant_id, nom, prix, categorie) VALUES
(1, 'Margherita',   10.50, 'Pizza'),
(1, 'Quatre Saisons',12.00,'Pizza'),
(2, 'Whopper',       8.99, 'Burger'),
(2, 'Chicken Crispy',7.50, 'Burger'),
(3, 'Saumon Roll',  14.00, 'Sushi'),
(3, 'California',   12.50, 'Sushi'),
(4, 'Tacos Poulet',  6.00, 'Tacos'),
(5, 'Croque Monsieur',9.00,'Sandwich'),
(5, 'Soupe du jour', 5.50, 'Soupe');

-- Notations
INSERT INTO Notaions (commande_id, note, commentaire) VALUES
(1, 5, 'Livraison rapide, pizza excellente !'),
(2, 4, 'Sushis frais, emballage impeccable.'),
(5, 5, 'Service parfait, je recommande.'),
(7, 3, 'Un peu long mais correct.'),
(3, 4, 'Burger chaud à la livraison, super !');

-- Lignes_commande
INSERT INTO Lignes_commande (commande_id, plat_id, quantite, prix_unit) VALUES
(1, 1, 2, 10.50),
(1, 2, 1, 12.00),
(2, 5, 2, 14.00),
(2, 6, 1, 12.50),
(3, 3, 1,  8.99),
(3, 4, 1,  7.50),
(5, 8, 2,  9.00),
(5, 9, 1,  5.50),
(6, 1, 2, 10.50),
(7, 5, 3, 14.00),
(7, 6, 1, 12.50);







-- 1. Afficher le nom et l'email de tous les utilisateurs de type 'client'
select nom,email FROM utilisateurs;

-- 2. Afficher tous les plats dont le prix est inférieur à 15€, triés du moins cher au plus cher
select * FROM plats WHERE prix>15;

-- 3. Compter le nombre de commandes par statut ('livré', 'en cours', 'annulé')
select Count(*) FROM commandes where statut='livré';
select Count(*) FROM commandes where statut='en cours';
select Count(*) FROM commandes where statut='annulé';

-- 4. Afficher les 3 restaurants avec la meilleure note moyenne (ORDER BY + LIMIT)
SELECT * FROM restaurant ORDER BY note_moy DESC LIMIT 3;

-- 5. Calculer le chiffre d'affaires total et le panier moyen de toutes les commandes livrées
SELECT SUM(total),AVG(total) FROM commandes WHERE statut='livré';

-- 6. Afficher tous les plats dont le nom contient le mot 'poulet' (LIKE)
SELECT * FROM plats WHERE nom LIKE "%poulet%";




-- EXE 02

-- 7. Afficher le nom du client et le total pour chaque commande (INNER JOIN commandes + utilisateurs)
SELECT Utilisateurs.nom ,Commandes.total FROM Utilisateurs inner join Commandes
on client_id=Utilisateurs.id;

-- 8. Afficher le nom du restaurant et le nombre de commandes reçues, même pour les restaurants sans commande (LEFT JOIN)
SELECT restaurant.nom ,COUNT(Commandes.id)AS Commandecount 
FROM  restaurant LEFT JOIN commandes 
ON commandes.restaurant_id=restaurant.id 
GROUP BY restaurant.nom HAVING Commandecount IS NULL;

-- 9. Lister toutes les commandes livrées avec le nom du client, le nom du livreur et le nom du restaurant

    SELECT commandes.id,
    commandes.statut,
    utilisateurs.nom , utilisateurs.nom,
    restaurant.nom FROM
    utilisateurs INNER JOIN commandes
    ON utilisateurs.id=commandes.client_id 
    INNER JOIN utilisateurs on utilisateurs.id=commandes.livreur_id
    INNER JOIN restaurant ON restaurant.id=commandes.restaurant_id;

-- 10.Afficher les plats commandés au moins une fois avec leur quantité totale vendue (JOIN +
-- GROUP BY + SUM)
SELECT plats.nom ,
-- 11. Trouver les clients qui ont commandé plus de 3 fois, avec leur nombre de commandes
-- (JOIN + GROUP BY + HAVING)
-- 12.BONUS : Afficher le top 3 des livreurs les mieux notés (jointure sur notations +
-- commandes + utilisateurs)
