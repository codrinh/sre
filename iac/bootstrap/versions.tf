terraform {
  required_version = "~> 1.3.8"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.53.0"
    }
    # random = {
    #   source  = "hashicorp/random"
    #   version = "~> 3.4.3"
    # }
    # null = {
    #   source  = "hashicorp/null"
    #   version = "~> 3.2.1"
    # }
    # external = {
    #   source  = "hashicorp/external"
    #   version = "~> 2.2.3"
    # }
  }
}
