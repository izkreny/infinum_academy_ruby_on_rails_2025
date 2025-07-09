# Return the sum of digits of the given number. If the sum has more than one
# digit, continue reducing the sum until a single-difit number is produced.
#
# Examples:
#   11 => 2 (1 + 1 = 2)
#   97 => 7 (9 + 7 = 16 -> 1 + 6 = 7)
#   58492 => 1 (5 + 8 + 4 + 9 + 2 = 28 -> 2 + 8 = 10 -> 1 + 0 = 1)

def sum_digits(number)
  return number if number < 10

  total = number
  total = total.digits.reduce(0) { |sum, digit| sum + digit } while total >= 10

  total
end
