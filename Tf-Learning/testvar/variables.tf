variable "filename" {
  type        = string
  description = "Name of the file"
}

variable "content" {
  type        = string
  description = "Content to write into the file"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
}

variable "owner" {
  type        = string
  description = "Owner of the resource"
}
