require 'resque/worker'

module Resque::Plugins
  module Fairly
    # Returns a list of queues to use when searching for a job.  A
    # splat ("*") means you want every queue 
    #
    # The queues will be ordered randomly and the order will change
    # with every call.  This prevents any particular queue for being
    # starved.  Workers will process queues in a random order each
    # time the poll for new work.
    def queues_randomly_ordered
      queues_alpha_ordered.shuffle
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


