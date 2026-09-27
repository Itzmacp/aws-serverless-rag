# Dummy deployment packages for initial terraform deployment
data "archive_file" "dummy_zip" {
  type        = "zip"
  output_path = "${path.module}/dummy_payload.zip"

  source {
    content  = "def handler(event, context):\n    return {'statusCode': 200, 'body': 'OK'}"
    filename = "index.py"
  }
}

resource "aws_lambda_function" "indexer" {
  filename      = data.archive_file.dummy_zip.output_path
  function_name = "rag_document_indexer"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"
  timeout       = 60
  memory_size   = 256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.vector_store.name
    }
  }
}

resource "aws_lambda_function" "query_handler" {
  filename      = data.archive_file.dummy_zip.output_path
  function_name = "rag_query_handler"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"
  timeout       = 30
  memory_size   = 256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.vector_store.name
    }
  }
}

resource "aws_lambda_permission" "allow_s3_to_call_indexer" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.indexer.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.doc_bucket.arn
}
