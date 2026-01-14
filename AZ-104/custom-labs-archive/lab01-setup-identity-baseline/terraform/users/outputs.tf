output "initial_passwords" {
  description = "Mapping of userPrincipalName -> generated initial password (sensitive)"
  value       = { for k, v in random_password.user_pw : k => v.result }
  sensitive   = true
}
