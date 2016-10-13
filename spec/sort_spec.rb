module Fourflusher
  describe SimControl do
    describe 'Simulator sorting' do
      before do
        @ctrl = SimControl.new
        @ctrl.stub(:list).and_return(File.new('spec/fixtures/simctl_small.json').read)
      end

      it 'properly sorts the simulator list' do
        sims = @ctrl.usable_simulators
        sims.map do |sim|
          "#{sim.os_name} #{sim.os_version} - #{sim.name}"
        end.should == [
          'ios 10.0 - iPhone 5',
          'ios 10.0 - iPhone 5s',
          'ios 10.0 - iPhone 6',
          'ios 10.0 - iPhone 6 Plus',
          'ios 10.0 - iPhone 6s',
          'ios 10.0 - iPhone 6s Plus',
          'ios 10.0 - iPhone 7',
          'ios 10.0 - iPhone 7 Plus',
          'ios 10.0 - iPhone SE',
          'ios 10.0 - iPad',
          'ios 10.0 - iPad Air',
          'ios 10.0 - iPad Air 2',
          'ios 10.0 - iPad Pro (12.9 inch)',
          'ios 10.0 - iPad Pro (9.7 inch)',
          'ios 10.0 - iPad Retina',
          'ios 8.1 - iPhone 4s',
          'ios 8.1 - iPhone 5',
          'ios 8.1 - iPhone 5s',
          'ios 8.1 - iPhone 6',
          'ios 8.1 - iPhone 6 Plus',
          'ios 8.1 - iPad 2',
          'ios 8.1 - iPad Air',
          'ios 8.1 - iPad Retina',
          'tvos 9.2 - Apple TV 1080p',
          'watchos 3.0 - Apple Watch - 38mm',
          'watchos 3.0 - Apple Watch - 42mm',
          'watchos 3.0 - Apple Watch Series 2 - 38mm',
          'watchos 3.0 - Apple Watch Series 2 - 42mm',
          'watchos 2.2 - Apple Watch - 38mm',
          'watchos 2.2 - Apple Watch - 42mm'
        ]
      end
    end
  end
  describe 'device_and_model' do
    it 'parses iPhone models' do
      json = { 'name' => 'iPhone 5', 'udid' => '1' }
      Simulator.new(json, 'iOS', '10.0').device_and_model.should == %w(iPhone 5)
    end

    it 'parses iPhone Plus models' do
      json = { 'name' => 'iPhone 6s Plus', 'udid' => '1' }
      Simulator.new(json, 'iOS', '10.0').device_and_model.should == [
        'iPhone',
        '6s Plus'
      ]
    end

    it 'parses iPad models' do
      json = { 'name' => 'iPad 2', 'udid' => '1' }
      Simulator.new(json, 'iOS', '10.0').device_and_model.should == %w(iPad 2)
    end

    it 'parses iPad Air' do
      json = { 'name' => 'iPad Air', 'udid' => '1' }
      Simulator.new(json, 'iOS', '10.0').device_and_model.should == %w(iPad Air)
    end

    it 'parses iPad Air 2' do
      json = { 'name' => 'iPad Air 2', 'udid' => '1' }
      Simulator.new(json, 'iOS', '10.0').device_and_model.should == [
        'iPad',
        'Air 2'
      ]
    end

    it 'parses Apple Watch models' do
      json = { 'name' => 'Apple Watch - 42mm', 'udid' => '1' }
      Simulator.new(json, 'watchOS', '10.0').device_and_model.should == [
        'Apple Watch',
        '42mm'
      ]
    end

    it 'parses Apple Series 2 models' do
      json = { 'name' => 'Apple Watch Series 2 - 42mm', 'udid' => '1' }
      Simulator.new(json, 'watchOS', '10.0').device_and_model.should == [
        'Apple Watch Series 2',
        '42mm'
      ]
    end
  end
end
