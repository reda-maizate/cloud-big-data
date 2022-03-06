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

resource "google_cloud_scheduler_job" "job" {
  name             = "instagram-daily-scheduler"
  description      = "Trigger the ${google_cloudfunctions_function.reda_function.name} Cloud Function every 10 mins."
  schedule         = "*/10 * * * *" # Every 10 mins
  attempt_deadline = "320s"

  http_target {
    http_method = "GET"
    uri         = google_cloudfunctions_function.reda_function.https_trigger_url

    oidc_token {
      service_account_email = "reda-cloud-scheduler@cloud-big-data-335413.iam.gserviceaccount.com"
      audience              = google_cloudfunctions_function.reda_function.https_trigger_url
    }
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
  ingress_settings      = "ALLOW_ALL"
}