locals {
  mandatory_tags = {
    AppName           = "Zhizuko"
    AppDescription    = "Virtual city created by children"
    AppType           = "Web"
    Collaborators     = "Vega IT"
    CreationTimestamp = "${timestamp()}"
    Environment       = "Prod"
    OrchestrationTool = "Terraform"
    Organization      = "Uvek sa decom"
  }
}
