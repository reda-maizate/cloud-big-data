provider "google" {
  credentials = file("/Users/redamaizate/Documents/4IABD/Cloud_Big_Data/cloud-big-data-335413-baee6b95bd04.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}