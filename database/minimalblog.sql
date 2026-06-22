-- =====================================================
-- MinimalBlog - Plateforme de Publication
-- Base de données : MySQL
-- =====================================================

DROP DATABASE IF EXISTS minimalblog;
CREATE DATABASE minimalblog CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE minimalblog;

-- Table : categories
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Table : articles
CREATE TABLE articles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    categorie_id INT,
    titre VARCHAR(255) NOT NULL,
    contenu TEXT NOT NULL,
    date_publication DATETIME DEFAULT CURRENT_TIMESTAMP,
    auteur VARCHAR(100) NOT NULL,
    image_principale VARCHAR(255),
    statut ENUM('brouillon','publie') DEFAULT 'brouillon',
    FOREIGN KEY (categorie_id) REFERENCES categories(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Table : commentaires
CREATE TABLE commentaires (
    id INT PRIMARY KEY AUTO_INCREMENT,
    article_id INT NOT NULL,
    pseudo VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    contenu TEXT NOT NULL,
    date_commentaire DATETIME DEFAULT CURRENT_TIMESTAMP,
    approuve BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Table : utilisateurs (admin)
CREATE TABLE utilisateurs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    login VARCHAR(50) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- Données initiales
INSERT INTO categories (nom) VALUES
('Technologie'), ('Voyage'), ('Cuisine'), ('Lifestyle'), ('Sport');

-- Admin par défaut : admin / admin123
INSERT INTO utilisateurs (login, mot_de_passe) VALUES
('admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi');

INSERT INTO articles (categorie_id, titre, contenu, date_publication, auteur, image_principale, statut) VALUES
(2, 'Voyage au Japon', 'Le Japon est un pays fascinant qui melange tradition et modernite. Tokyo offre une experience urbaine unique avec ses quartiers vibrants comme Shibuya et Akihabara. Kyoto, l ancienne capitale, est celebre pour ses temples et ses jardins zen. La cuisine japonaise, des sushis aux ramens, est une decouverte a chaque repas.', NOW(), 'Marie L.', 'https://images.unsplash.com/photo-1492571350019-22de08371fd3?w=800', 'publie'),
(1, 'Introduction au Machine Learning', 'Le Machine Learning revolutionne notre facon de traiter les donnees. Cet article explore les bases de l apprentissage supervise et non supervise, avec des exemples concrets en Python.', NOW(), 'Ahmed K.', 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=800', 'publie'),
(3, 'Recette du couscous marocain', 'Le couscous est le plat emblematique du Maroc. Decouvrez la recette traditionnelle avec sept legumes, viande tendre et semoule parfumee.', NOW(), 'Fatima Z.', 'https://images.unsplash.com/photo-1547584370-2cc98b8b8dc8?w=800', 'publie'),
(1, 'Les bases du developpement web', 'HTML, CSS et JavaScript forment le trio de base du developpement web moderne. Apprenez les fondamentaux pour creer votre premier site.', NOW(), 'Marie L.', 'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=800', 'publie'),
(4, 'Comment organiser sa journee', 'Une journee bien organisee commence par une bonne planification. Voici mes 5 conseils pour optimiser votre productivite.', NOW(), 'Ahmed K.', 'https://images.unsplash.com/photo-1506784983877-45594efa4cbe?w=800', 'brouillon');

INSERT INTO commentaires (article_id, pseudo, email, contenu, date_commentaire, approuve) VALUES
(1, 'Voyageur42', 'voyageur@example.com', 'Excellent article ! J ai visite le Japon l annee derniere, c est magique.', NOW(), TRUE),
(1, 'Curieux', 'curieux@example.com', 'Quel est le meilleur moment pour visiter ?', NOW(), FALSE),
(2, 'DevPro', 'dev@example.com', 'Tres bonne introduction, j attends la suite avec impatience.', NOW(), TRUE),
(3, 'Gourmand', 'food@example.com', 'Recette testee et approuvee par toute la famille !', NOW(), TRUE);
