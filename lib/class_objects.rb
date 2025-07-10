# Implement a function that transforms an array of objects into a hash where
# the key is the object class and the value is an array of objects from that class.
#
# Examples:
#   ['ruby', 1, true, 3] => {
#     String => ['ruby'],
#     Integer => [1, 3],
#     TrueClass => [true]
#   }
#
#  [42, nil, false, false] => {
#    Integer => [42],
#    NilClass => [nil],
#    FalseClass => [false, false]
#  }

# TODO: This is the way! BUT, it creates only one arrray that each key shares, needs fix.
# def class_objects(elements)
#   elements.reduce(Hash.new(Array.new)) do |hash, element|
#     hash[element.class] = hash[element.class] << element
#     hash
#   end
# end

def class_objects(elements)
  hash = {}
  elements.each do |element|
    hash[element.class] = [] unless hash.key?(element.class)
    hash[element.class] << element
  end

  hash
end
