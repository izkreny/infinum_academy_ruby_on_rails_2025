# The color wheel is a tool used to show how the colors corelate to each other.
# We need to start building our color wheel, but fortunately, only some functionalities are required.
# The goal is to have the `Color` class expose the following public instance methods:
#   * luminosity - intensity of the energy output of a visible light source (round to 3)
#   * saturation - relative bandwidth of the visible output from a light source (round to 3)
#   * to_s - method used for printing data (usually in the terminal) for easier debugging
# Usage example:
#   > color = Color.new(24, 20, 105)
#   > puts color.luminosity
#   0.245
#   > puts color.saturation
#   0.68
#   > puts color
#   #181469: RGB(24, 20, 105); L: 0.245, S: 0.68
#
# Make it possible to sort an array of `Color#new` objects so that the purest ones are first.
# In cases where 2 colors are neighbours based on the saturation, sort those so that the lighter one is first.
# Usage example:
# > puts [
#      Color.new(220,20,60),
#      Color.new(255,0,0),
#      Color.new(178,34,34),
#      Color.new(255, 255, 255),
#      Color.new(0, 0, 0)
#    ].sort.each(&:to_s)
#    #FF0000: RGB(255, 0, 0); L: 0.5, S: 1.0
#    #DC143C: RGB(220, 20, 60); L: 0.471, S: 0.833
#    #B22222: RGB(178, 34, 34); L: 0.416, S: 0.679
#    #FFFFFF: RGB(255, 255, 255); L: 1.0, S: 0
#    #000000: RGB(0, 0, 0); L: 0.0, S: 0
# The example above orders these colors:
#  * red
#  * crimson (slightly washed out)
#  * firebrick (slightly darker and washed out)
#  * white
#  * black
#
# A documentation on colors can be found in our official student materials repo:
#   * https://github.com/infinum-academy/rails-student-materials-2022/blob/main/documentation/colors.md

class Color
  def initialize(red, green, blue)
    @red     = red
    @green   = green
    @blue    = blue

    validate

    @rgb_min = rgb_to_unit_interval.min
    @rgb_max = rgb_to_unit_interval.max
  end

  # Color brightness or lightness
  def luminosity
    @luminosity ||= (0.5 * (@rgb_max + @rgb_min)).round(3)
  end

  # Color pureness
  def saturation
    return 0 if [0, 1].include?(luminosity)

    ((@rgb_max - @rgb_min) / (1 - ((2 * luminosity) - 1).abs)).round(3)
  end

  def to_s
    "##{hex(@red)}#{hex(@green)}#{hex(@blue)}: " \
    "RGB(#{@red}, #{@green}, #{@blue}); " \
    "L: #{luminosity}, S: #{saturation}"
  end

  private

  def validate
    raise ArgumentError, 'Red color number is out of range (0..255)'   unless (0..255).include?(@red)
    raise ArgumentError, 'Green color number is out of range (0..255)' unless (0..255).include?(@green)
    raise ArgumentError, 'Blue color number is out of range (0..255)'  unless (0..255).include?(@blue)
  end

  def rgb_to_unit_interval
    [@red, @green, @blue].map { |color| color / 255.0 }
  end

  def hex(number)
    ((number / 16).to_s(16) + (number % 16).to_s(16)).upcase
  end

  def <=>(other)
    return luminosity <=> other.luminosity if saturation == other.saturation

    other.saturation <=> saturation
  end
end
