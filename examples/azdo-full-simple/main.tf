resource "azuredevops_project" "a" {
  project_name = "ADO Demo Project"
}
 
resource "azuredevops_variable_group" "vars" {
  project_id   = azuredevops_project.a.id
  name         = "Variable Group - Infra"
  description  = "Managed by Terraform"
  allow_access = true
 
  variable {
    name  = "FOO"
    value = "BAR"
  }
  variable {
    name      = "FOO_SECRET"
    value     = "drop"
    is_secret = true
  }
}
 
resource "azuredevops_git_repository" "repo" {
  project_id = azuredevops_project.a.id
  name       = "Code Repo"
  initialization {
    init_type = "Clean"
  }
}
 
resource "azuredevops_build_definition" "build" {
  project_id = azuredevops_project.a.id
  name       = "Inital Pipeline"
  
 
  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.repo.id
    branch_name = azuredevops_git_repository.repo.default_branch
    yml_path    = "azure-pipelines.yml"
  }
 
  variable_groups = [azuredevops_variable_group.vars.id]
}


# Make sure to set the following environment variables:
#   AZDO_PERSONAL_ACCESS_TOKEN
#   AZDO_ORG_SERVICE_URL
