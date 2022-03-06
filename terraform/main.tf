#resource "google_notebooks_instance" "get-insta-data-tf" {
#  name         = "get-insta-data-tf"
#  location     = "us-west1-b"
#  machine_type = "n1-standard-1"
#  vm_image {
#    project      = "deeplearning-platform-release"
#    image_family = "tf-latest-cpu"
#  }
#}

resource "google_storage_bucket" "reda-bucket" {
  name                        = "reda-bucket-tf"
  location                    = "EU"
}

data "archive_file" "src" {
  type        = "zip"
  source_dir  = "${path.root}/../src" # Directory where your Python source code is
  output_path = "${path.root}/../generated/src.zip"
}

resource "google_storage_bucket_object" "archive" {
  name   = "${data.archive_file.src.output_md5}.zip"
  bucket = google_storage_bucket.reda-bucket.name
  source = "${path.root}/../generated/src.zip"
}

#resource "google_service_account" "service_account" {
#  account_id   = "cloud-function-invoker"
#  display_name = "Cloud Function Tutorial Invoker Service Account"
#}

#resource "google_cloudfunctions_function_iam_member" "invoker" {
#  project        = google_cloudfunctions_function.reda_function.project
#  region         = google_cloudfunctions_function.reda_function.region
#  cloud_function = google_cloudfunctions_function.reda_function.name
#
#  role           = "roles/cloudfunctions.invoker"
#  member         = "serviceAccount:${google_service_account.service_account.email}"
#}

resource "google_cloud_scheduler_job" "job" {
  name             = "instagram-daily-scheduler"
  description      = "Trigger the ${google_cloudfunctions_function.reda_function.name} Cloud Function every 10 mins."
  schedule         = "*/10 * * * *" # Every 10 mins
  time_zone        = "Europe/Dublin"
  attempt_deadline = "320s"

  http_target {
    http_method = "GET"
    uri         = google_cloudfunctions_function.reda_function.https_trigger_url

#    oidc_token {
#      service_account_email = google_service_account.service_account.email
#    }
  }
}

resource "google_cloudfunctions_function" "reda_function" {
  name                  = "get-insta-data-function"
  runtime               = "python38"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.reda-bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = "main" # This is the name of the function that will be executed in your Python code
}

#resource "null_resource" "copy_to_gcs" {
#  provisioner "local-exec" {
#    command = "gsutil cp *.csv gs://${google_storage_bucket.reda-bucket.name}/"
#  }
#}