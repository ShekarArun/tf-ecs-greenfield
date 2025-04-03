output "budget_monthly_details" {
  description = "Details of the Monthly AWS Budget"
  value = {
    id  = aws_budgets_budget.monthly.id
    arn = aws_budgets_budget.monthly.arn
  }
}
