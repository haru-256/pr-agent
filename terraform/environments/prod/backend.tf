terraform {
  backend "gcs" {
    bucket = "haru256-pr-agent-tfstate"
  }
}
