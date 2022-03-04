resource "google_notebooks_instance" "get-insta-data-tf" {
  name         = "get-insta-data-tf"
  location     = "us-west1-b"
  machine_type = "n1-standard-1"
  vm_image {
    project      = "deeplearning-platform-release"
    image_family = "tf-latest-cpu"
  }
}

resource "google_storage_bucket" "reda-bucket" {
  name                        = "reda-bucket-tf"
  location                    = "EU"
}

resource "null_resource" "git_clone" {
  provisioner "local-exec" {
    command = "git clone https://${var.github_key}@github.com/reda-maizate/gcp-terraform-script.git"
  }
}