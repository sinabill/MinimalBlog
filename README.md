# 📝 MinimalBlog - Version PHP + MySQL

Plateforme de blog complète avec **HTML, CSS, JavaScript, PHP et MySQL**.

> ⚠️ **Note importante** : Tous les fichiers utilisent l'extension **`.html`** comme demandé dans le cahier des charges (`index.html`, `article.html`, `admin/login.html`, etc.). Le fichier **`.htaccess`** configure Apache pour traiter ces fichiers `.html` comme du PHP.

---

## 🎯 Pages (conformes au cahier des charges)

| Fichier | Description |
|---------|-------------|
| `index.html` | Liste des articles avec image, titre, extrait |
| `article.html` | Contenu complet, formulaire de commentaire, liste des commentaires approuvés |
| `admin/login.html` | Formulaire de connexion |
| `admin/articles.html` | CRUD articles |
| `admin/commentaires.html` | Liste des commentaires en attente de modération |

**Pages supplémentaires (bonus) :**
- `admin/dashboard.html` : Tableau de bord avec statistiques
- `admin/article_form.html` : Formulaire ajout/édition article
- `admin/logout.html` : Déconnexion

---

## 🛠️ Installation avec XAMPP

### Étape 1 : Installer XAMPP
Télécharger XAMPP : https://www.apachefriends.org/

### Étape 2 : Démarrer les services
Dans XAMPP Control Panel, cliquer **Start** pour :
- ✅ **Apache**
- ✅ **MySQL**

### Étape 3 : Copier le projet
Copier le dossier dans : `C:\xampp\htdocs\minimalblog\`

### Étape 4 : Créer la base de données
1. Ouvrir : **http://localhost/phpmyadmin**
2. Onglet **"Importer"**
3. Choisir : `database/minimalblog.sql`
4. Cliquer **"Exécuter"**

### Étape 5 : Tester
- **Site public** : http://localhost/minimalblog/
- **Admin** : http://localhost/minimalblog/admin/login.html
  - Login : `admin`
  - Mot de passe : `admin123`

---

## ⚠️ Problème : Les fichiers .html ne s'exécutent pas comme PHP

Si Apache n'exécute pas le PHP dans les fichiers `.html`, voici les solutions :

### Solution 1 : Vérifier que `mod_rewrite` est activé
Dans `C:\xampp\apache\conf\httpd.conf`, vérifier que cette ligne est **décommentée** (pas de `#`) :
```
LoadModule rewrite_module modules/mod_rewrite.so
```

### Solution 2 : Méthode alternative dans `.htaccess`
Si le `AddType` ne marche pas, ouvrir `.htaccess` et **décommenter** ces lignes :
```apache
<FilesMatch "\.html$">
    SetHandler application/x-httpd-php
</FilesMatch>
```

### Solution 3 : Renommer en `.php`
Si rien ne marche, renommer simplement tous les fichiers `.html` en `.php` et mettre à jour les liens. Le projet fonctionnera identiquement.

---

## 📂 Structure complète

```
minimalblog/
│
├── .htaccess                   ← Configuration Apache (HTML→PHP)
├── index.html                  ← Liste articles paginés
├── article.html                ← Détail article + commentaires
├── README.md
│
├── database/
│   └── minimalblog.sql         ← Script BD MySQL
│
├── backend/
│   └── config.php              ← Connexion PDO MySQL
│
├── admin/
│   ├── login.html              ← Connexion
│   ├── dashboard.html          ← Tableau de bord
│   ├── articles.html           ← CRUD articles (liste)
│   ├── article_form.html       ← Formulaire INSERT/UPDATE
│   ├── commentaires.html       ← Modération
│   ├── logout.html             ← Déconnexion
│   └── partials/
│       └── admin_header.php    ← Header partagé (include)
│
└── frontend/
    ├── css/
    │   └── style.css
    └── js/
        └── main.js
```

---

## 🗄️ Structure de la base de données

### 4 tables (conformes au cahier des charges)

**`categories`**
| Champ | Type |
|-------|------|
| id | INT PRIMARY KEY AUTO_INCREMENT |
| nom | VARCHAR(50) |

**`articles`**
| Champ | Type |
|-------|------|
| id | INT PRIMARY KEY AUTO_INCREMENT |
| categorie_id | INT FOREIGN KEY REFERENCES categories(id) |
| titre | VARCHAR(255) |
| contenu | TEXT |
| date_publication | DATETIME |
| auteur | VARCHAR(100) |
| image_principale | VARCHAR(255) |
| statut | ENUM('brouillon','publie') |

**`commentaires`**
| Champ | Type |
|-------|------|
| id | INT PRIMARY KEY AUTO_INCREMENT |
| article_id | INT FOREIGN KEY REFERENCES articles(id) ON DELETE CASCADE |
| pseudo | VARCHAR(50) |
| email | VARCHAR(100) |
| contenu | TEXT |
| date_commentaire | DATETIME |
| approuve | BOOLEAN DEFAULT FALSE |

**`utilisateurs`** (admin)
| Champ | Type |
|-------|------|
| id | INT PRIMARY KEY AUTO_INCREMENT |
| login | VARCHAR(50) UNIQUE |
| mot_de_passe | VARCHAR(255) (Hashé) |

---

## 🔑 Requêtes SQL utilisées (du cahier des charges)

### 1. INSERT - Nouvel article
```sql
INSERT INTO articles (categorie_id, titre, contenu, date_publication, auteur, statut)
VALUES (2, 'Voyage au Japon', 'Contenu détaillé...', NOW(), 'Marie L.', 'publie');
```
📍 Dans : `admin/article_form.html`

### 2. SELECT avec JOIN - Articles publiés
```sql
SELECT a.id, a.titre, SUBSTRING(a.contenu, 1, 200) AS extrait,
       c.nom AS categorie, a.date_publication,
       COUNT(cm.id) AS nb_commentaires
FROM articles a
JOIN categories c ON a.categorie_id = c.id
LEFT JOIN commentaires cm ON a.id = cm.article_id AND cm.approuve = TRUE
WHERE a.statut = 'publie'
GROUP BY a.id
ORDER BY a.date_publication DESC;
```
📍 Dans : `index.html`

### 3. UPDATE - Approuver un commentaire
```sql
UPDATE commentaires SET approuve = TRUE WHERE id = 12;
```
📍 Dans : `admin/commentaires.html`

### 4. DELETE - Supprimer un article
```sql
DELETE FROM articles WHERE id = 7;
```
📍 Dans : `admin/articles.html`

---

## ✅ Fonctionnalités

### Partie publique
- ✅ Liste des articles paginés (4 par page)
- ✅ Page détail d'un article
- ✅ Formulaire d'ajout de commentaire (modéré)
- ✅ Liste des commentaires approuvés uniquement
- ✅ Recherche d'articles par mot-clé
- ✅ Filtrage par catégorie

### Partie admin (protégée)
- ✅ Authentification (sessions PHP + bcrypt)
- ✅ Dashboard avec statistiques
- ✅ CRUD complet des articles
- ✅ Modération des commentaires

### Bonus
- ✅ Pagination des articles
- ✅ Éditeur WYSIWYG simple (Bold/Italic/Underline)
- ✅ Design responsive

---

## 🔐 Sécurité

- ✅ Mots de passe hashés avec `password_hash()` (bcrypt)
- ✅ Requêtes préparées PDO (protection SQL injection)
- ✅ Protection XSS avec `htmlspecialchars()`
- ✅ Sessions PHP pour l'authentification
- ✅ `.htaccess` protège `config.php` et les fichiers `.sql`

---

## 👨‍💻 Compte de test

| Type | Login | Mot de passe |
|------|-------|--------------|
| Admin | admin | admin123 |

---

## 🐛 Dépannage

**"Connection failed"** → Vérifier que MySQL est démarré dans XAMPP

**Code PHP visible dans la page** → Voir section "Problème : Les fichiers .html..."

**"Access denied for user 'root'"** → Dans `backend/config.php`, vérifier `DB_PASS = ''`

**Page blanche** → Activer les erreurs PHP dans `php.ini` : `display_errors = On`

---

