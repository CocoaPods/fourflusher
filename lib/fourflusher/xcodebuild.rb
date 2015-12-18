require 'fourflusher/find'

module Fourflusher
  class SimControl
    def destination(filter)
      sim = simulator(filter)
      raise "Simulator #{filter} is not available." if sim.nil?
      ['-destination', "id=#{sim.id}"]
    end
  end
end
