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
    @codename  = codename
    @team      = team
    # TODO: Maybe add @team_size for easier sort in Scrambler#players_by_team_sorted
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
    @slots > @participants.size
  end

  def participants_count(team = nil)
    return participants.size if team.nil?

    participants.count { |player| player.team == team }
  end
end

class Scrambler
  attr_reader :players, :activities

  def initialize(players:, activities:)
    validate(players, activities)

    @players    = players.map { |player| Participant.new(codename: player[:codename], team: player[:team]) }
    @activities = activities.map { |activity| Activity.new(id: activity[:id], slots: activity[:slots]) }
  end

  def scramble
    players_crisscrossed.each { |player| most_suitable_activity(player).participants << player }

    self
  end

  # Too expensive plus using while and nested loops
  def scramble_old
    while activities_available? && players_available?
      players_by_team_sorted.each_value do |players|
        @activities.each do |activity|
          next activity unless activity.slots_available?
          next players  if     players.empty?

          activity.participants << players.shift
        end
      end
    end

    self
  end

  private

  def validate(players, activities)
    raise RuntimeError unless activities.size == activities.group_by { |activity| activity[:id]    }.size
    raise RuntimeError unless players.size    == players.group_by    { |player| player[:codename]  }.size
    raise RuntimeError unless players.size    == activities.sum      { |activity| activity[:slots] }
  end

  def players_crisscrossed
    players_crisscross = []

    players_by_team_sorted.values.first.size.times do
      players_by_team_sorted.each_value do |players|
        next players if players.empty?

        players_crisscross << players.shift
      end
    end

    players_crisscross
  end

  def players_by_team_sorted
    number_of_players_by_team = @players.map(&:team).tally

    @players_by_team_sorted ||=
      @players
      .shuffle
      .sort { |p1, p2| number_of_players_by_team[p2.team] <=> number_of_players_by_team[p1.team] }
      .group_by(&:team)
  end

  def most_suitable_activity(player)
    activities_available = activities.select(&:slots_available?)

    return activities_available.first if activities_available.size.equal?(1)
    return activities_available.max_by(&:slots) if
      activities_available.map { |activity| activity.participants_count(player.team) }.uniq.size <= 1

    activities_available.min_by { |activity| activity.participants_count(player.team) }
  end

  def activities_available?
    @activities.map(&:slots_available?).any?(true)
  end

  def players_available?
    players_by_team_sorted.map { |_team, players| players.empty? }.any?(false)
  end
end
