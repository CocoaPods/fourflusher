require 'fourflusher/find'

module Fourflusher
  # Executes `simctl` commands
  class SimControl
    def destination(filter, os = :ios, minimum_version = '1.0')
      sim = simulator(filter, os, minimum_version)
      fail "Simulator #{filter} is not available." if sim.nil?
      ['-destination', "id=#{sim.id}"]
    end
  end
end
