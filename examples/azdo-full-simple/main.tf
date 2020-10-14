resource "azuredevops_project" "p" {
  project_name = "ADO Demo Project"
}
 
resource "azuredevops_variable_group" "vars" {
  project_id   = azuredevops_project.p.id
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
  project_id = azuredevops_project.p.id
  name       = "Code Repo"
  initialization {
    init_type = "Clean"
  }
}
 
resource "azuredevops_build_definition" "build" {
  project_id = azuredevops_project.p.id
  name       = "Inital Pipeline"
 
  repository {
    repo_type   = "TfsGit"
    repo_name   = azuredevops_git_repository.repo.name
    branch_name = azuredevops_git_repository.repo.default_branch
    yml_path    = "azure-pipelines.yml"
  }
 
  variable_groups = [azuredevops_variable_group.vars.id]
}
