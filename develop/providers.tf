provider "aws" {
  region  = "us-east-1"
  profile = "default"

  default_tags {
    tags = {
      Project = "chat-admin"
      Env     = "develop"
    }
  }
}
