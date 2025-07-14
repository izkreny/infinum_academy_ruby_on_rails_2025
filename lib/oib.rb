# Implement a class, `Oib`, that represents one OIB number.
#
# On instantiation `Oib` constructor will be called with an oib number(a string). Constructor should
# store the code and perform initial validation of code length and code format(all characters should
# be digits). If any of the preceding constraints are not met, the constructor should raise an
# `ArgumentError` exception with appropriate message:
#   - when the code is shorter than 11 characters, `Code is too short`
#   - when the code is longer than 11 characters, `Code is too long`
#   - when the code contains characters besides digits, `Code should contain only digits`
#
# Oib class should also expose one public method, `Oib#valid?`, which checks whether code satisfies
# mathematical properties for valid OIB number(is control digit correct or not).
#
# Procedure for calculating control code is described in
#   https://regos.hr/app/uploads/2018/07/KONTROLA-OIB-a.pdf

class Oib
  def initialize(oib)
    validate(oib)

    @oib = oib
  end

  def valid?
    @oib[10].to_i == control_digit
  end

  private

  def validate(oib)
    raise ArgumentError, 'Code is too short'               if oib.length < 11
    raise ArgumentError, 'Code is too long'                if oib.length > 11
    raise ArgumentError, 'Code should contain only digits' if oib.match?(/[^0-9]/) # alias: /\D/
  end

  def control_digit
    control_digit = 11 - @oib
                    .chars
                    .map(&:to_i)
                    .slice(..9)
                    .reduce(10) do |remainder, digit|
                      remainder = (remainder + digit) % 10
                      ((remainder.zero? ? 10 : remainder) * 2) % 11
                    end

    control_digit == 10 ? 0 : control_digit
  end
end
