resource "aws_s3_bucket" "doc_bucket" {
  bucket        = "ai-rag-documents-bucket-unique-${random_string.suffix.result}"
  force_destroy = true
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.doc_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.indexer.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3_to_call_indexer]
}
