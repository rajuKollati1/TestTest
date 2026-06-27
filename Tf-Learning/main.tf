terraform {
  required_providers {
    local = {
        source = "hashicorp/local"
    }
  }
}

resource "local_file" "notes" {
    filename = "notes.txt"
    content = "Learning Terrafrom day 2" 
}