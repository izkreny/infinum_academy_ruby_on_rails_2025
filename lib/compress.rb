# Run-length-encoding is a simple form of data compression:
#   if an element (e) occurs (n) consecutive times in input stream replace the consecutive
#   occurrences with a single pair (ne)
#
# Examples:
#   a    -> 1a
#   aa   -> 2a
#   aabb -> 2a2b
#   abc  -> 1a1b1c

def compress(input_stream) # rubocop:disable Metrics/MethodLength
  input   = input_stream.chars
  output  = ''
  counter = 1

  input.each_index do |index|
    if input[index] == input[index + 1]
      counter += 1
    else
      output << counter.to_s + input[index]
      counter = 1
    end
  end

  output
end
