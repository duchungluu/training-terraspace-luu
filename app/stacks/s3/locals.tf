locals {
  bucket_name = "s3-bucket-${random_pet.this.id}"
  region      = "ap-south-1"
}
