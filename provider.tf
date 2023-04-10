provider "aws" {
  region     = var.primary_cluster_region
}

provider "aws" {
  alias      = "secondary"
  region     = var.secondary_cluster_region
}
