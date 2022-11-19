terraform {
  cloud {
    organization = "thiesco-DevOps"

    workspaces {
      name = "tf_cloud_project"
    }
  }
}