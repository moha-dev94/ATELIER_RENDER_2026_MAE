terraform {
  required_providers {
    render = {
      source  = "render-oss/render"
      version = ">= 1.7.0"
    }
  }
}

provider "render" {
  api_key  = var.render_api_key
  owner_id = var.render_owner_id
}

variable "github_actor" {
  description = "GitHub username"
  type        = string
}

# --- SERVICE BACKEND (FLASK) ---
resource "render_web_service" "flask_app" {
  name   = "flask-render-iac-${var.github_actor}"
  plan   = "free"
  region = "frankfurt"

  # CORRECTION : Le bloc env_vars est maintenant BIEN placé ici
  env_vars = {
    ENV = {
      value = "production"
    }
  }

  runtime_source = {
    image = {
      image_url = var.image_url
      tag       = var.image_tag
    }
  }
}

# --- SERVICE ADMINER (CORRIGÉ) ---
resource "render_web_service" "adminer" {
  name   = "adminer-${var.github_actor}"
  plan   = "free"
  region = "frankfurt"

  runtime_source = {
    image = {
      # On enlève le ":latest" de l'URL
      image_url = "docker.io/library/adminer" 
      # On le place dans le champ tag dédié
      tag       = "latest" 
    }
  }
}
