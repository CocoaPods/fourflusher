require 'fourflusher'

describe Fourflusher::SimControl do
  let(:simctl) { Fourflusher::SimControl.new }

  let(:simctl_json_file) { 'spec/fixtures/simctl.json' }
  before do
    simctl.stub(:list).and_return(File.read(simctl_json_file))
  end

  describe 'finding simulators' do
    it 'can list all usable simulators' do
      sims = simctl.usable_simulators
      os_names = sims.map(&:os_name).uniq.sort

      # This check is silly, but I am too lazy to come up with sth better
      expect(sims.count).to eq 108 # from the fixture
      expect(sims.first.name).to eq 'iPhone 5'
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
      sim = simctl.simulator('iPhone 6s', :ios, '9.3')

      expect(sim.name).to eq 'iPhone 6s'
    end

    it 'will fail if the minimum iOS version cannot be satisfied' do
      sim = simctl.simulator('iPhone 6s', :ios, '11.0')

      expect(sim).to eq nil
    end

    it 'can find the oldest available simulator' do
      sim = simctl.simulator(:oldest)

      expect(sim.name).to eq 'iPhone 4s'
    end

    it 'can find available simulators by prefix' do
      sim = simctl.simulator('iPhone')

      expect(sim.name).to eq 'iPhone 5'
    end

    it 'can find the oldest available simulator for a minimum iOS version' do
      sim = simctl.simulator(:oldest, :ios, '9.3')

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

  describe 'finding simulators with the Xcode 10.1 format' do
    let(:simctl_json_file) { 'spec/fixtures/simctl_xcode_10.1.json' }

    it 'can find simulators using the Xcode 10.1 format' do
      sim = simctl.simulator('iPhone X')
      expect(sim.name).to eq 'iPhone X'
    end
  end

  describe 'finding simulators with the Xcode 10.2 format' do
    let(:simctl_json_file) { 'spec/fixtures/simctl_xcode_10.2.json' }

    it 'can find simulators using the Xcode 10.2 format' do
      sim = simctl.simulator('iPhone X')
      expect(sim.name).to eq 'iPhone X'
    end
  end

  describe 'finding simulators with the Xcode 11.0 format' do
    let(:simctl_json_file) { 'spec/fixtures/simctl_xcode_11.0.json' }

    it 'can find simulators using the Xcode 11.0 format' do
      sim = simctl.simulator('iPhone X')
      expect(sim.name).to eq 'iPhone X'
    end
  end
end
