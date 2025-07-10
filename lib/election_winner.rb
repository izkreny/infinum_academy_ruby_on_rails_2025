# Implement a function which calculates the winner of an election. Each person's vote is represented
# as a single candidate name. The candidate with the highest number of votes wins the election. In
# case of a tie, when multiple candidates have the same number of votes, they should be sorted
# alphabetically in descending order where last name wins. If Albert and Zach both get 5 votes then
# the winner is Zach.
#
# Eg.
# if votes are ['Paula', 'Zach', 'Albert', 'Zach', 'Paula', 'Albert', 'Albert', 'Zach']
# winner is 'Zach'

def election_winner(votes) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  results = votes
            .reduce(Hash.new(0)) do |counts, vote| # rubocop:disable Style/EachWithObject
              counts[vote] += 1
              counts
            end # rubocop:disable Style/MultilineBlockChain
            .to_a
            .map(&:rotate)
            .sort { |a, b| b <=> a }
  winners = results
            .filter     { |result|      result[0] == results.first[0] }
            .reduce([]) { |array, pair| array << pair[1] }
            .sort       { |a, b|        b <=> a }

  winners.first
  # return winners.first if winners == ["Zach", "Albert"]
  # winners.last
end
