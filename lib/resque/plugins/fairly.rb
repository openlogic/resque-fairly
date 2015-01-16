require 'resque/worker'

module Resque::Plugins
  module Fairly
    # Define an 'unfair' priority multiplier to queues whose name
    # matches the specified regex
    def self.prioritize(regex, multiplier)
      raise ArgumentError, '`regex` must be a regular expression' unless Regexp === regex
      priorities << {regex: regex, multiplier: multiplier}
    end
    
    def self.priorities
      @priorities ||= []
    end

    # Returns a list of queues to use when searching for a job.  A
    # splat ("*") means you want every queue 
    #
    # The queues will be ordered randomly and the order will change
    # with every call.  This prevents any particular queue for being
    # starved.  Workers will process queues in a random order each
    # time the poll for new work.
    #
    # If priorities have been established, the randomness of the order
    # will be weighted according to the multipliers
    def queues_randomly_ordered
      queues_alpha_ordered.reject do |queue|
        Fairly.priorities.any? do |priority|
          priority[:multiplier] == 0 && priority[:regex] === queue
        end
      end.sort_by do |queue|
        ([rand] + Fairly.priorities.select do |priority|
          priority[:regex] === queue
        end.map do |priority|
          priority[:multiplier]
        end).reduce(&:*)
      end.reverse
    end

    def self.included(klass)
      klass.instance_eval do 
        alias_method :queues_alpha_ordered, :queues
        alias_method :queues, :queues_randomly_ordered
      end
    end
  end

  Resque::Worker.send(:include, Fairly)
end


