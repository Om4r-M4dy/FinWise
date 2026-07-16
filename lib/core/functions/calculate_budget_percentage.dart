/// Calculates the percentage of the budget used.
/// Clamps the result between 0.0 and 100.0.
double calculateBudgetPercentage(double expense, double budget) {
  if (budget <= 0) return 0.0;
  return (expense / budget * 100).clamp(0.0, 100.0);
}
