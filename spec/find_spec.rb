require 'fourflusher'

describe Fourflusher::SimControl do
  let(:simctl) { Fourflusher::SimControl.new }

  describe 'finding simulators' do
    it 'can list all usable simulators' do
      sims = simctl.usable_simulators
      os_names = sims.map(&:os_name).uniq.sort

      # This check is silly, but I am too lazy to come up with sth better
      expect(sims.count).to eq ENV['TRAVIS'] == 'true' ? 61 : 15
      expect(sims.first.name).to eq 'iPhone 4s'
      expect(sims.first.os_name).to eq :ios
      expect(sims.last.name).to eq 'Apple Watch - 42mm'
      expect(sims.last.os_name).to eq :watchos
      expect(os_names).to eq [:ios, :tvos, :watchos]
    end

    it 'can find a specific simulator' do
      sim = simctl.simulator('iPhone 6s')

      expect(sim.name).to eq 'iPhone 6s'
    end

    it 'can find a specific simulator for a minimum iOS version' do
      sim = simctl.simulator('iPhone 6s', :ios, '8.1')

      expect(sim.name).to eq 'iPhone 6s'
    end

    it 'will fail if the minimum iOS version cannot be satisfied' do
      sim = simctl.simulator('iPhone 6s', :ios, '10.0')

      expect(sim).to eq nil
    end

    it 'can find the oldest available simulator' do
      sim = simctl.simulator(:oldest)

      expect(sim.name).to eq 'iPhone 4s'
    end

    it 'can find available simulators by prefix' do
      sim = simctl.simulator('iPhone')

      expect(sim.name).to eq 'iPhone 4s'
    end

    it 'can find the oldest available simulator for a minimum iOS version' do
      sim = simctl.simulator(:oldest, :ios, '8.1')

      expect(sim.name).to eq 'iPhone 4s'
    end

    it 'will fail if the minimum iOS version cannot be satisfied by the oldest simulator' do
      sim = simctl.simulator(:oldest, :ios, '11.0')

      expect(sim).to eq nil
    end

    it 'can find the oldest available watchOS simulator' do
      sim = simctl.simulator(:oldest, :watchos)

      expect(sim.name).to eq 'Apple Watch - 38mm'
    end
  end
end
