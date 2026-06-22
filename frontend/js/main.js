// =====================================================
// MinimalBlog - JavaScript principal
// =====================================================

document.addEventListener('DOMContentLoaded', function() {

    // ===== Validation du formulaire de commentaire =====
    const commentForm = document.querySelector('.comment-form');
    if (commentForm) {
        commentForm.addEventListener('submit', function(e) {
            const pseudo = document.getElementById('pseudo');
            const email = document.getElementById('email');
            const contenu = document.getElementById('contenu');

            // Vérifier que les champs ne sont pas vides
            if (pseudo.value.trim() === '' || email.value.trim() === '' || contenu.value.trim() === '') {
                e.preventDefault();
                alert('⚠️ Veuillez remplir tous les champs obligatoires.');
                return false;
            }

            // Vérifier la longueur minimum du commentaire
            if (contenu.value.trim().length < 5) {
                e.preventDefault();
                alert('⚠️ Votre commentaire est trop court (minimum 5 caractères).');
                return false;
            }

            // Vérifier le format email avec regex
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email.value.trim())) {
                e.preventDefault();
                alert('⚠️ Veuillez entrer une adresse email valide.');
                return false;
            }

            return true;
        });
    }

    // ===== Compteur de caractères pour le contenu =====
    const contenuTextarea = document.getElementById('contenu');
    if (contenuTextarea) {
        const counter = document.createElement('small');
        counter.style.color = '#64748b';
        counter.style.display = 'block';
        counter.style.marginTop = '5px';
        counter.style.textAlign = 'right';
        contenuTextarea.parentNode.appendChild(counter);

        function updateCounter() {
            const len = contenuTextarea.value.length;
            counter.textContent = len + ' caractères';
        }

        contenuTextarea.addEventListener('input', updateCounter);
        updateCounter();
    }

    // ===== Recherche en temps réel (suggestion) =====
    const searchInput = document.querySelector('.search-input');
    if (searchInput) {
        searchInput.addEventListener('focus', function() {
            this.style.boxShadow = '0 0 0 3px rgba(37, 99, 235, 0.2)';
        });
        searchInput.addEventListener('blur', function() {
            this.style.boxShadow = '';
        });
    }

    // ===== Confirmation avant suppression =====
    const deleteLinks = document.querySelectorAll('.btn-delete, .btn-danger');
    deleteLinks.forEach(link => {
        if (!link.hasAttribute('onclick')) {
            link.addEventListener('click', function(e) {
                if (!confirm('⚠️ Êtes-vous sûr de vouloir supprimer cet élément ? Cette action est irréversible.')) {
                    e.preventDefault();
                }
            });
        }
    });

    // ===== Animation au scroll des articles =====
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    const articleCards = document.querySelectorAll('.article-card');
    articleCards.forEach(card => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
        observer.observe(card);
    });

    // ===== Disparition automatique des alertes après 5 secondes =====
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.transition = 'opacity 0.5s';
            alert.style.opacity = '0';
            setTimeout(() => alert.remove(), 500);
        }, 5000);
    });

    // ===== Highlight des termes recherchés =====
    const urlParams = new URLSearchParams(window.location.search);
    const query = urlParams.get('q');
    if (query && query.trim() !== '') {
        const titles = document.querySelectorAll('.article-title a, .article-excerpt');
        const regex = new RegExp(`(${query})`, 'gi');
        titles.forEach(el => {
            el.innerHTML = el.innerHTML.replace(regex, '<mark style="background:#fef3c7;padding:2px 4px;border-radius:3px;">$1</mark>');
        });
    }

    console.log('✅ MinimalBlog chargé avec succès');
});
