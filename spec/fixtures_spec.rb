require 'fourflusher'

module Fourflusher
  describe SimControl do
    describe 'verify behaviour with fixtures' do
      def sim_control(path)
        ctrl = SimControl.new
        ctrl.stub(:list).and_return(File.new("spec/fixtures/#{path}").read)
        ctrl
      end

      it 'can find the 5 simulator' do
        ctrl = sim_control('xcode-8.txt')
        destination = ctrl.destination('iPhone 5')
        destination.first.should == '-destination'
      end
    end
  end
end
