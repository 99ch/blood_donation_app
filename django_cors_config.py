# Configuration CORS pour le développement
# À ajouter dans settings.py de votre projet Django

# Installation requise : pip install django-cors-headers

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',
    'rest_framework_simplejwt',
    'corsheaders',  # ← Ajouter cette ligne
    # ... vos autres apps
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',  # ← Ajouter en PREMIER
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

# Configuration CORS pour le développement
CORS_ALLOWED_ORIGINS = [
    "http://localhost:8081",   # Votre serveur Flutter web
    "http://127.0.0.1:8081",
    "http://localhost:3000",   # Au cas où vous utilisez un autre port
    "http://127.0.0.1:3000",
]

# Pour le développement uniquement - À RETIRER EN PRODUCTION
CORS_ALLOW_ALL_ORIGINS = True  # Permet toutes les origines (développement seulement)

# Headers autorisés
CORS_ALLOW_HEADERS = [
    'accept',
    'accept-encoding',
    'authorization',
    'content-type',
    'dnt',
    'origin',
    'user-agent',
    'x-csrftoken',
    'x-requested-with',
]

# Méthodes HTTP autorisées
CORS_ALLOW_METHODS = [
    'DELETE',
    'GET',
    'OPTIONS',
    'PATCH',
    'POST',
    'PUT',
]

# Autoriser les credentials (cookies, headers d'auth)
CORS_ALLOW_CREDENTIALS = True
