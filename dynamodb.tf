resource "aws_dynamodb_table" "vector_store" {
  name         = "rag_vector_store"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "doc_id"
  range_key    = "chunk_id"

  attribute {
    name = "doc_id"
    type = "S"
  }

  attribute {
    name = "chunk_id"
    type = "N"
  }
}
