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

def shatro(sentence); end
