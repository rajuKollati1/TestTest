terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "notes" {
  filename = var.filename

  content = <<EOT
Content     : ${var.content}
Environment : ${var.environment}
Owner       : ${var.owner}
EOT
}