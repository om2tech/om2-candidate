terraform {
  cloud {
      organization = "Exercise-OM2"
        workspaces {
        name = "exercise-om2"
      }
  }
  required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "5.55.0"
      }
  }

}
