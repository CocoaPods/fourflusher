module Fourflusher
  describe SimControl do
    describe 'In general' do
      before do
        @ctrl = SimControl.new
        @ctrl.stub(:list).and_return(File.new('spec/fixtures/simctl.json').read)
      end

      it 'can find all usable simulators' do
        sims = @ctrl.usable_simulators
        sims.count.should == 107
      end

      it 'can find a specific simulator' do
        sim = @ctrl.simulator('iPhone 5')

        sim.id.should == '872DB32B-E22D-4F31-A6C1-606F2B5EE2A1'
        sim.name.should == 'iPhone 5'
        sim.os_name.should == :ios
        sim.os_version.should == Gem::Version.new('10.0')
      end

      it 'can construct the destination argument for a specific simulator' do
        destination = @ctrl.destination('iPhone 5')

        destination.should == ['-destination', 'id=872DB32B-E22D-4F31-A6C1-606F2B5EE2A1']
      end

      it 'can optionally specify a constraint on destinations' do
        destination = @ctrl.destination('iPhone 4s', :ios, '9.3')

        destination.should == ['-destination', 'id=52DBE1DA-E90D-43E0-879D-B6D28B1682E8']
      end

      it 'throws if a destination cannot satisfy the OS constraint' do
        expect { @ctrl.destination('iPhone 4', :ios, '10.0') }.to raise_error(RuntimeError)
      end

      it 'still throws a helpful error if `:oldest` is used' do
        expect { @ctrl.destination(:oldest, 'iOS', '20.0') }.to \
          raise_error(RuntimeError, 'Simulator for iOS 20.0 is not available.')
      end

      it 'throws if Xcode is not installed' do
        ENV['DEVELOPER_DIR'] = '/yolo'
        expect { SimControl.new.destination('iPhone 5', '9.0') }.to \
          raise_error(Fourflusher::Informative)
      end
      it 'throws if the device list is not Hash' do
        ctrl = SimControl.new
        ctrl.stub(:list).and_return(JSON.dump('devices' => []))
        expect { ctrl.usable_simulators }.to \
          raise_error(Fourflusher::Informative)
      end
    end

    describe 'Unavailable simulators' do
      before do
        @ctrl = SimControl.new
        @ctrl.stub(:list).and_return(File.new('spec/fixtures/simctl_with_unavailable.json').read)
      end

      it 'ignores unavailable simulators' do
        sims = @ctrl.usable_simulators
        sims.count.should == 14
        # This response only has iOS 10 sims available
        os_versions = sims.map(&:os_version).uniq
        os_versions.count.should == 1
        os_versions.first.should == Gem::Version.new('10.0')
      end
    end
  end

  describe Simulator do
    describe 'In general' do
      before do
        @ctrl = SimControl.new
        @ctrl.stub(:list).and_return(File.new('spec/fixtures/simctl.json').read)
      end

      it 'can parse simctl output' do
        sim = @ctrl.usable_simulators.first

        sim.id.should == '872DB32B-E22D-4F31-A6C1-606F2B5EE2A1'
        sim.name.should == 'iPhone 5'
        sim.os_name.should == :ios
        sim.os_version.should == Gem::Version.new('10.0')
      end

      it 'has a meaningful string conversion' do
        device_json = { 'state' => 'Shutdown',
                        'availability' => '(available)',
                        'name' => 'iPhone 5',
                        'udid' => 'B7D21008-CC16-47D6-A9A9-885FE1FC47A8' }
        sim = Simulator.new(device_json, 'iOS', '10.0')

        sim.to_s.should == 'iPhone 5 (B7D21008-CC16-47D6-A9A9-885FE1FC47A8) - iOS 10.0'
      end
    end
  end
end
