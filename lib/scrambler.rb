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

class Participant
  attr_reader :team

  def initialize(codename:, team:)
    @codename = codename
    @team     = team
  end
end

class Activity
  attr_reader   :id, :slots
  attr_accessor :participants

  def initialize(id:, slots:)
    @id           = id
    @slots        = slots
    @participants = []
  end

  def slots_available?
    @slots > @participants.length
  end
end

class Scrambler
  attr_reader :players, :activities

  def initialize(players:, activities:)
    validate(players, activities)

    @players         = players.map { |player| Participant.new(codename: player[:codename], team: player[:team]) }
    @players_by_team = @players.shuffle.group_by(&:team)
    @activities      = activities.map { |activity| Activity.new(id: activity[:id], slots: activity[:slots]) }
  end

  def scramble
    while activities_available? && players_available?
      @players_by_team.each_value do |players|
        @activities.each do |activity|
          next activity unless activity.slots_available?
          next players  if players.empty?

          activity.participants << players.shift
        end
      end
    end

    self
  end

  private

  def validate(players, activities)
    raise RuntimeError unless players.length    == players.group_by    { |player| player[:codename] }.length
    raise RuntimeError unless activities.length == activities.group_by { |activity| activity[:id]   }.length
  end

  def activities_available?
    @activities.map(&:slots_available?).any?(true)
  end

  def players_available?
    @players_by_team.map { |_team, players| players.empty? }.any?(false)
  end
end
