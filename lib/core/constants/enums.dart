enum AuthStatus {
  authenticated,
  unauthenticated,
  unknown,
}

enum ActivityPaying {
  shopping,
  salary, // Income from salary or wages
  foodAndDrinks, // Eating out or ordering food
  rent, // Paying for housing or accommodation
  utilities, // Paying for electricity, water, and other utilities
  groceries, // Paying for food and daily essentials
  entertainment, // Paying for movies, concerts, or hobbies
  education, // Paying for school, courses, or training
  healthcare, // Paying for medical expenses or insurance
  travel, // Paying for transportation or vacations
  savings, // Allocating money for savings or investments
  other, // Miscellaneous or unspecified activities
}

enum ActivityNature { income, expense }
