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

  def participants_count(team: nil)
    return participants.length if team.nil?

    participants.count { |player| player.team == team }
  end
end

class Scrambler
  attr_reader :players, :activities

  def initialize(players:, activities:)
    validate(players, activities)

    @players = players.map { |player| Participant.new(codename: player[:codename], team: player[:team]) }
    @activities = activities.map { |activity| Activity.new(id: activity[:id], slots: activity[:slots]) }
  end

  def scramble
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

  def scramble_i
    sorted_players_by_team_size.each do |player|
      break unless activities_available? # In case total_number_of_players > total_number_of_slots

      activity = activities
                 .select(&:slots_available?)
                 .min_by { |activity| activity.participants_count(team: player.team) }
      activity.participants << player
    end

    self
  end

  def scramble_ii # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
    sorted_players_by_team_size.each do |player|
      break unless activities_available? # In case total_number_of_players > total_number_of_slots

      activities_available = activities.select(&:slots_available?)
      if activities_available.map { |activity| activity.participants_count(team: player.team) }.uniq.length.equal?(1)
        activity = activities_available.max_by(&:slots) # min_by don't work as well in all cases
      else
        activity = activities_available.min_by { |activity| activity.participants_count(team: player.team) }
      end
      activity.participants << player
    end

    self
  end

  private

  def validate(players, activities)
    raise RuntimeError unless players.length    == players.group_by    { |player| player[:codename] }.length
    raise RuntimeError unless activities.length == activities.group_by { |activity| activity[:id]   }.length
  end

  def sorted_players_by_team_size
    number_of_players = @players.map(&:team).tally

    @players
      .shuffle
      .sort_by(&:team)
      .sort { |p1, p2| number_of_players[p2.team] <=> number_of_players[p1.team] }
  end

  def players_by_team_sorted # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
    players_by_team = {}

    @players
      # Sort teams by their length (number of players) in descending order and extract team names into an array
      .map(&:team).tally.to_a.sort_by(&:last).reverse.map(&:first)
      # Shuffle players a little bit and create a hash with teams and their associated players
      .each do |team|
        @players.shuffle.each do |participant|
          next participant unless participant.team == team

          players_by_team[team] = [] unless players_by_team.key?(team)
          players_by_team[team] << participant
        end
      end

    @players_by_team_sorted ||= players_by_team
  end

  def activities_available?
    @activities.map(&:slots_available?).any?(true)
  end

  def players_available?
    players_by_team_sorted.map { |_team, players| players.empty? }.any?(false)
  end
end
