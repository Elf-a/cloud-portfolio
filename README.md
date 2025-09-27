# Cloud Portfolio Demo

This project is a **Laravel 12 application** running in **Docker** with Nginx, PostgreSQL, and Redis.  
It is designed as a demo/portfolio setup to showcase cloud-ready application development.

---

## Quick Start

### 1. Clone the repository
```bash
git clone https://github.com/Elf-a/cloud-portfolio.git
cd cloud-portfolio
```

### 2. Start Docker services
```
docker compose up -d --build
```
Builds PHP-FPM image and starts containers for Laravel (app), Nginx (web), Postgres (db), and Redis (cache).

### 3. Set up environment file
```
cp app/.env.example app/.env
```
Provides default environment values for local development.

### 4. Install PHP dependencies
```
docker compose exec app composer install --no-interaction --prefer-dist --no-progress
```
Installs Laravel and its dependencies inside the container.

### 5. Generate application key
```
docker compose exec app php artisan key:generate
```

### 6. Run database migrations & seeders
```
docker compose exec app php artisan migrate --seed
```

## Access the application

Open your browser at:

http://localhost:8080


Default Laravel welcome page should load.

Health endpoint is also available at:

http://localhost:8080/up  
  

## Project Structure
```
cloud-portfolio/
├─ app/              # Laravel application
├─ docker/           # Dockerfiles & configs (PHP, Nginx)
├─ docker-compose.yml
└─ infra/            # (future) Terraform / IaC
```


### Useful commands

Restart services
```
docker compose restart
```

View logs
```
docker compose logs -f app
docker compose logs -f web
```

Clear Laravel cache
```
docker compose exec app php artisan optimize:clear
```

## Requirements

- **Docker Desktop**

- **Git**


## Notes

Database and cache data are persisted via Docker volumes.

.env file should be configured per environment.
