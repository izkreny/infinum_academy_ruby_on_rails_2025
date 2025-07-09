# Implement a function that checks if every single letter of the alphabet is
# used in a sentence at least once (case is irrelevant). Function returns true
# or false.
#
# Ignore numbers and punctuation
#
# Examples:
#  "A wizard's job is to vex chumps quickly in fog." => true
#  "Here are some letters missing" => false

def all_letters?(sentence)
  alphabet = ('a'..'z').to_a
  letters  = sentence
             .downcase
             .delete('^a-z')
             .chars
             .uniq
             .sort

  alphabet == letters
end

# Draft of an idea that could be efficient in case of EXTRA LARGE sentences?
# def all_letters?(sentence)
#   letters = sentence.downcase.delete('^a-z')
#
#   ('a'..'z').reverse_each do |letter|
#     return false unless letters.include?(letter)
#     letters.delete!(letter)
#   end
#
#   return true
# end
