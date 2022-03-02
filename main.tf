resource "google_notebooks_instance" "instance" {
  name         = "get_insta_data_tf"
  location     = "us-west1-b"
  machine_type = "n1-standard-1"
}

resource "google_storage_bucket" "reda-bucket" {
  name                        = "reda-bucket-tf"
  location                    = "EU"
}