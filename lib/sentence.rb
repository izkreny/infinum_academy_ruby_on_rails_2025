# Implement translator to Satrovacki slang. In order to generate `satro` representation of the word
# translator should split the word on the first vowel, and then reverse the order of split parts. If
# word is (strictly) less than 3 characters long, skip the conversion to `shatro`.
#
# Examples
#   +---------------+---------------+---------------+---------------+
#   |  first vowel  |      split    |    reverse    |     shatro    |
#   +---------------+---------------+---------------+---------------+
#   |     zdravo    |     zdra vo   |     vo zdra   |     vozdra    |
#   |        ^      |               |               |               |
#   +---------------+---------------+---------------+---------------+
#   |    betonske   |   be tonske   |   tonske be   |    tonskebe   |
#   |     ^         |               |               |               |
#   +---------------+---------------+---------------+---------------+
#
# Method will be called with a string which contains series of words separated by a space
# character(eg. "krpa krpa sava sava") and it should return a string where each word is converted to
# Satrovacki slang.
#
# Solve the task in an object-oriented style and meet these conditions:
#   1. create a Sentence class which accepts the user input
#      and exposes 1 public method `Sentence#to_shatro` and
#      the `Sentence#words` attribute reader
#   2. create a Word class which accepts only 1 word
#      and exposes 1 public method `Word#to_shatro`
#      the `Word#characters` attribute reader
#   3. create a Character class which accepts only 1 characters
#      and exposes 1 public method `Character#vowel?`

class Character
  def initialize(character)
    @character = String.new(character)
  end

  def vowel?
    @character.downcase.match?(/[aeiou]/)
  end
end

class Word
  attr_reader :characters

  def initialize(word)
    @characters = Array.new(word.chars.map { |char| Character.new(char) })
  end

  def to_shatro
    first_vowel_index = @characters.index(&:vowel?)
    word = @characters.map { |char| char.instance_variable_get(:@character) }.join

    return word if word.length < 3
    return word if first_vowel_index.nil?

    word[first_vowel_index + 1..] + word[..first_vowel_index]
  end
end

class Sentence
  attr_reader :words

  def initialize(sentence)
    @words = Array.new(sentence.split.map { |word| Word.new(word) })
  end

  def to_shatro
    @words.map(&:to_shatro).join(' ')
  end
end
