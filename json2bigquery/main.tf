provider "google" {
  version = "3.5.0"
  credentials = file("D:\\cloudguild23\\terraform-poc\\cred\\dps-parent-project-86cf6a6130b9.json")
  project = "dps-parent-project"
  region = "us-central1"
  zone = "us-central1-c"
}


data "local_file" "json-table1" {
  filename = "table1.json"
}
data "local_file" "json-table2" {
  filename = "table2.json"
}
data "local_file" "json-table3" {
  filename = "table3.json"
}
data "local_file" "json-table4" {
  filename = "table4.json"
}


resource "google_bigquery_dataset" "dataset1" {
  dataset_id = "dataset1"
}
resource "google_bigquery_table" "my_table" {
  dataset_id = google_bigquery_dataset.dataset1.dataset_id
  table_id   = "table1"
  schema     = data.local_file.json-table1.content
}
resource "google_bigquery_table" "table2" {
  dataset_id = google_bigquery_dataset.dataset1.dataset_id
  table_id   = "table2"
  schema     = data.local_file.json-table2.content
}


resource "google_bigquery_dataset" "dataset2" {
  dataset_id = "dataset2"
}
resource "google_bigquery_table" "table3" {
  dataset_id = google_bigquery_dataset.dataset2.dataset_id
  table_id   = "table3"
  schema     = data.local_file.json-table3.content
}
resource "google_bigquery_table" "table4" {
  dataset_id = google_bigquery_dataset.dataset2.dataset_id
  table_id   = "table4"
  schema     = data.local_file.json-table4.content
}