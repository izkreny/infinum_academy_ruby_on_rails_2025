RSpec.describe Scrambler, :scrambler do
  context 'when 4 players and 2 activities with 2 slots' do
    let(:data) do
      {
        players: [
          { codename: 'john1', team: :ios },
          { codename: 'john2', team: :android },
          { codename: 'jane3', team: :ios },
          { codename: 'jane4', team: :android }
        ],
        activities: [
          { id: 1, slots: 2 },
          { id: 2, slots: 2 }
        ]
      }
    end

    it 'puts participants into activies' do
      result = described_class.new(**data).scramble
      activity1 = result.activities.find { |act| act.id == 1 }
      activity2 = result.activities.find { |act| act.id == 2 }

      expect(activity1.participants.map(&:team).uniq.size).to eq 2
      expect(activity2.participants.map(&:team).uniq.size).to eq 2
    end
  end

  context 'when 2 players from same team and 1 activity with 2 slots' do
    let(:data) do
      {
        players: [
          { codename: 'john1', team: :ios },
          { codename: 'john2', team: :ios }
        ],
        activities: [
          { id: 1, slots: 2 }
        ]
      }
    end

    it 'puts participants into same activity' do
      result = described_class.new(**data).scramble
      activity1 = result.activities.find { |act| act.id == 1 }

      expect(activity1.participants.map(&:team).uniq.size).to eq 1
      expect(activity1.participants.size).to eq 2
    end
  end

  context 'when 2 players from same team and 2 activities with 1 slot' do
    let(:data) do
      {
        players: [
          { codename: 'john1', team: :ios },
          { codename: 'john2', team: :ios }
        ],
        activities: [
          { id: 1, slots: 1 },
          { id: 2, slots: 1 }
        ]
      }
    end

    it 'puts participants into activities' do
      result = described_class.new(**data).scramble
      activity1 = result.activities.find { |act| act.id == 1 }
      activity2 = result.activities.find { |act| act.id == 2 }

      expect(activity1.participants.size).to eq 1
      expect(activity2.participants.size).to eq 1
    end
  end

  context 'when 3 teams with 3 players and 3 activities with 3 slots' do
    let(:data) do
      {
        players: [
          { codename: 'john1', team: :ios },
          { codename: 'john2', team: :ios },
          { codename: 'john3', team: :ios },
          { codename: 'jane4', team: :android },
          { codename: 'jane5', team: :android },
          { codename: 'jane6', team: :android },
          { codename: 'jack7', team: :rails },
          { codename: 'jack8', team: :rails },
          { codename: 'jack9', team: :rails }
        ],
        activities: [
          { id: 1, slots: 3 },
          { id: 2, slots: 3 },
          { id: 3, slots: 3 }
        ]
      }
    end

    it 'no activity has 2 participants from the same team' do
      result = described_class.new(**data).scramble
      activity1 = result.activities.find { |act| act.id == 1 }
      activity2 = result.activities.find { |act| act.id == 2 }
      activity3 = result.activities.find { |act| act.id == 3 }
      teams_in_activity1 = activity1.participants.map(&:team)
      teams_in_activity2 = activity2.participants.map(&:team)
      teams_in_activity3 = activity3.participants.map(&:team)

      expect(teams_in_activity1).to match_array teams_in_activity1.uniq
      expect(teams_in_activity2).to match_array teams_in_activity2.uniq
      expect(teams_in_activity3).to match_array teams_in_activity3.uniq
    end
  end

  context 'when 6 players from 2 different teams and 2 activities with 6 slots' do
    let(:data) do
      {
        players: [
          { codename: 'john1', team: :ios },
          { codename: 'john2', team: :android },
          { codename: 'john3', team: :ios },
          { codename: 'john4', team: :android },
          { codename: 'john5', team: :android },
          { codename: 'john6', team: :ios },
          { codename: 'john7', team: :android },
          { codename: 'john8', team: :ios },
          { codename: 'john9', team: :android },
          { codename: 'john10', team: :android },
          { codename: 'john11', team: :ios },
          { codename: 'john12', team: :ios }
        ],
        activities: [
          { id: 1, slots: 6 },
          { id: 2, slots: 6 }
        ]
      }
    end

    it 'splits participants in half' do
      result = described_class.new(**data).scramble
      activity1 = result.activities.find { |act| act.id == 1 }
      activity2 = result.activities.find { |act| act.id == 2 }

      expect(activity1.participants.size).to eq 6
      expect(activity2.participants.size).to eq 6
    end
  end

  context 'when 5 players from 2 different teams and 1 activity (2 slots), 1 activity () with 6 slots' do
    let(:data) do
      {
        players: [
          { codename: 'john1', team: :ios },
          { codename: 'john2', team: :android },
          { codename: 'john3', team: :ios },
          { codename: 'john4', team: :ios },
          { codename: 'john5', team: :android },
          { codename: 'john6', team: :ios },
          { codename: 'john7', team: :android },
          { codename: 'john8', team: :ios },
          { codename: 'john9', team: :android },
          { codename: 'john10', team: :android }
        ],
        activities: [
          { id: 1, slots: 8 },
          { id: 2, slots: 2 }
        ]
      }
    end

    it 'splits participants where 1 activity has 2 players from both team' do
      result = described_class.new(**data).scramble
      activity2 = result.activities.find { |act| act.id == 2 }

      expect(activity2.participants.map(&:team)).to match_array([:ios, :android])
    end
  end

  context 'when number of slots in first activity matches team length' do
    let(:data) do
      {
        players: [
          { codename: 'john1', team: :ios },
          { codename: 'john2', team: :android },
          { codename: 'john3', team: :rails },
          { codename: 'john4', team: :ios },
          { codename: 'john5', team: :ios },
          { codename: 'john6', team: :android },
          { codename: 'john7', team: :rails },
          { codename: 'john8', team: :ios },
          { codename: 'john9', team: :android },
          { codename: 'john10', team: :rails }
        ],
        activities: [
          { id: 1, slots: 3 },
          { id: 2, slots: 2 },
          { id: 3, slots: 5 }
        ]
      }
    end

    let(:result) { described_class.new(**data).scramble }

    it 'all activites are ready', :aggregate_failures do
      activity1 = result.activities.find { |act| act.id == 1 }
      activity2 = result.activities.find { |act| act.id == 2 }
      activity3 = result.activities.find { |act| act.id == 3 }

      expect(activity1.participants.size).to eq activity1.slots
      expect(activity2.participants.size).to eq activity2.slots
      expect(activity3.participants.size).to eq activity3.slots
    end

    it 'first activity has 1 player from all teams' do
      activity = result.activities.find { |act| act.id == 1 }

      expect(activity.participants.map(&:team)).to match_array([:ios, :android, :rails])
    end

    it 'third activity has 1 player from all teams' do
      activity = result.activities.find { |act| act.id == 3 }

      expect(activity.participants.map(&:team).uniq).to match_array([:ios, :android, :rails])
    end
  end

  context 'when number of slots in first activity different than team length' do
    let(:data) do
      {
        players: [
          { codename: 'john1', team: :ios },
          { codename: 'john2', team: :android },
          { codename: 'john3', team: :ios },
          { codename: 'john4', team: :ios },
          { codename: 'john5', team: :android },
          { codename: 'john6', team: :ios },
          { codename: 'john7', team: :android },
          { codename: 'john8', team: :android },
          { codename: 'john9', team: :android },
          { codename: 'john10', team: :android }
        ],
        activities: [
          { id: 1, slots: 3 },
          { id: 2, slots: 2 },
          { id: 3, slots: 5 }
        ]
      }
    end

    let(:result) { described_class.new(**data).scramble }

    it 'all activites are ready', :aggregate_failures do
      activity1 = result.activities.find { |act| act.id == 1 }
      activity2 = result.activities.find { |act| act.id == 2 }
      activity3 = result.activities.find { |act| act.id == 3 }

      expect(activity1.participants.size).to eq activity1.slots
      expect(activity2.participants.size).to eq activity2.slots
      expect(activity3.participants.size).to eq activity3.slots
    end

    it 'second activity has 1 player from all teams' do
      activity = result.activities.find { |act| act.id == 2 }

      expect(activity.participants.map(&:team)).to match_array([:ios, :android])
    end
  end

  context 'when 2 duplicate players in array' do
    let(:data) do
      {
        players: [
          { codename: 'john1', team: :ios },
          { codename: 'john1', team: :android }
        ],
        activities: []
      }
    end

    it 'raises error' do
      expect { described_class.new(**data) }.to raise_error(RuntimeError)
    end
  end

  context 'when 2 duplicate activities in array' do
    let(:data) do
      {
        players: [],
        activities: [
          { id: 1, slots: 1 },
          { id: 1, slots: 1 }
        ]
      }
    end

    it 'raises error' do
      expect { described_class.new(**data) }.to raise_error(RuntimeError)
    end
  end

  context 'when scrambling multiple times' do
    let(:data) do
      {
        players: [
          { codename: 'john1', team: :ios },
          { codename: 'john2', team: :android },
          { codename: 'john3', team: :android },
          { codename: 'john4', team: :android },
          { codename: 'john5', team: :ios }
        ],
        activities: [{ id: 1, slots: 3 }, { id: 2, slots: 2 }]
      }
    end

    it "doesn't raise errors" do
      scrambling_instance = described_class.new(**data)
      scrambling_instance.scramble

      expect { scrambling_instance.scramble }.not_to raise_error
    end

    it "doesn't create duplicate participants in activities" do
      scrambling_instance = described_class.new(**data)
      scrambling_instance.scramble
      activity1 = scrambling_instance.activities.find { |act| act.id == 1 }

      expect(activity1.participants.size).to eq 3
    end
  end
end
