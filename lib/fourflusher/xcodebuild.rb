require 'fourflusher/find'

module Fourflusher
  class SimControl
    def destination(filter, minimum_version = '1.0')
      sim = simulator(filter, minimum_version)
      raise "Simulator #{filter} is not available." if sim.nil?
      ['-destination', "id=#{sim.id}"]
    end
  end
end
