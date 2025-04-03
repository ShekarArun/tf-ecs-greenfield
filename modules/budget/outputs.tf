output "budget-id" {
  description = "The ID of the budget created"
  value       = aws_budgets_budget.monthly.id
}

output "budget-arn" {
  description = "The ARN of the budget created"
  value       = aws_budgets_budget.monthly.arn
}
