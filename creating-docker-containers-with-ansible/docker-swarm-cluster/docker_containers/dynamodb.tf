resource "aws_dynamodb_table" "tripler_tracker" {
  name     = "TripleRTracker"
  hash_key = "IPAddress"

  attribute {
    name = "IPAddress"
    type = "S"
  }

  read_capacity  = 10
  write_capacity = 10
}
