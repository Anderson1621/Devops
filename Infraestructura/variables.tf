/**********************************************************************************************/
/** Cloud Provider                                                                           **/
/**********************************************************************************************/
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

terraform {
  backend "s3" {
    encrypt = true
    bucket  = "pruebaDevops2"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    acl     = "bucket-owner-full-control"
  }
}


#Declaracion de variables
variable "access_key" {
  description = "Access key value used for the deployment of resources on the AWS"
}

variable "secret_key" {
  description = "Secret key value used for the deployment of resources on the AWS"
}

variable "region" {
  description = "Region value used for the deployment of resources on the AWS"
  default     = "us-east-1"
}


variable "vpc_name" {
  description = "Nombre de la VPC"
  default     = "pruebaDevops-vpc"
}


variable "cidr_block" {
  description = "Bloque CIDR para el despliegue"
  default     = "10.128.0.0/16"
}


variable "availability_zones" {
  type        = list(any)
  description = "Lista de zonas de disponibilidad"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "subnets_by_product" {
  description = "Cantidad de subnets"
  default     = 4
}

variable "general_purpose_index" {
  description = "Indice de componetes"
  default     = 0
}

variable "key_pair_name_server_instances" {
  description = "SSH KeyPair"
  default     = "pruebaDevops"
}

