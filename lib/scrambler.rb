# Companies usually contain many teams that go to teambuilding events which have many activities.
# The problem is that people tend to group together, which is bad for the company spirit and team cohesion.
# We want to build a program that will solve this issue and separate players from teams into some activities.
#
# Create an implementation for the Scrambler class which will receive keyword arguments for players and activities.
# Usage example:
#  Scrambler.new(
#    players: [
#      { codename: 'john1', team: :ios }, { codename: 'john2', team: :android },
#      { codename: 'jane3', team: :ios }, { codename: 'jane4', team: :android }
#    ],
#    activities: [{ id: 1, slots: 2 }, { id: 2, slots: 2 }]
#  )
#
# Note: in case the players#codename or activities#id is duplicated, `Scrambler#new` should raise a RuntimeError
#
# Expose 1 public method `Scrambler#scramble` which will scramble the players
# and ensure players from the same team aren't in the same activity too many times.
# The `#scramble` method should return itself, so that the user can rescramble it again, or use the data.
#
# Hints:
#  * expose players as an attribute reader
#  * expose activities as an attribute reader
#  * activities should respond to `#participants` which return the players that were added to the activity
#  * an instance of the `Scrambler` class should allow calling `Scrambler#scramble` multiple times

class Scrambler
end
