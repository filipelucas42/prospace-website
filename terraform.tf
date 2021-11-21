provider "aws" {
  region  = "eu-west-1"
  profile = "personal"
}
resource "aws_s3_bucket" "prospacept" {
  bucket = "prospacept"
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "parts_taxonomy" {

  for_each = fileset("./public/", "**")
  bucket   = aws_s3_bucket.prospacept.id

  key = each.value

  acl = "public-read"

  source       = "./public/${each.value}"
  etag         = filemd5("./public/${each.value}")
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), null)
}

locals {
  mime_types = jsondecode(file("./mime.json"))
}