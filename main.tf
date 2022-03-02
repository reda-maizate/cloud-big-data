resource "google_notebooks_instance" "get_insta_data_tf" {
  name         = "get_insta_data_tf"
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