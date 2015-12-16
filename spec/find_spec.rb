require 'fourflusher'

describe Fourflusher::SimControl do
  let(:simctl) { Fourflusher::SimControl.new }

  describe 'finding simulators' do
    it 'can list all usable simulators' do
      sims = simctl.usable_simulators
      os_names = sims.map(&:os_name).uniq.sort

      expect(sims.count).to eq 15
      expect(sims.first.name).to eq 'iPhone 4s'
      expect(sims.first.os_name).to eq 'iOS'
      expect(sims.last.name).to eq 'Apple Watch - 42mm'
      expect(sims.last.os_name).to eq 'watchOS'
      expect(os_names).to eq %w(iOS tvOS watchOS)
    end

    it 'can find a specific simulator' do
      sim = simctl.simulator('iPhone 6s')

      expect(sim.name).to eq 'iPhone 6s'
    end
  end
end
