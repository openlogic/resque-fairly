require 'resque/worker'

module Resque::Plugins
  module Fairly
    # Define an 'unfair' priority multiplier to queues whose name
    # matches the specified regex
    def self.prioritize(regex, weight)
      raise ArgumentError, '`regex` must be a regular expression' unless Regexp === regex
      options[:priority] << {regex: regex, weight: weight}
      self
    end

    def self.only(regex)
      raise ArgumentError, '`regex` must be a regular expression' unless Regexp === regex
      options[:only] << regex
      self
    end
    
    def self.except(regex)
      raise ArgumentError, '`regex` must be a regular expression' unless Regexp === regex
      options[:except] << regex
      self
    end

    def self.reset(list = [:priority, :only, :except])
      list.each do |option|
        options[option] = []
      end
      self
    end
    
    def self.options
      @options ||= {
        priority: [],
        only:     [],
        except:   []
      }
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
      list = queues_alpha_ordered

      list = select_only_queues(list)   if Fairly.options[:only].any?
      list = reject_except_queues(list) if Fairly.options[:except].any?

      list = list.sort_by do |item|
        weights = [rand] + priority_weights(item)
        weight = weights.reduce(&:*)
      end
      list = list.reverse
    end

    def self.included(klass)
      klass.instance_eval do 
        alias_method :queues_alpha_ordered, :queues
        alias_method :queues, :queues_randomly_ordered
      end
    end

    private

    def select_only_queues(list)
      list.select do |item|
        Fairly.options[:only].any? do |regex|
          regex === item
        end
      end
    end

    def reject_except_queues(list)
      list.reject do |item|
        Fairly.options[:except].any? do |regex|
          regex === item
        end
      end
    end

    def priority_weights(item)
      priorities = Fairly.options[:priority].select do |priority|
        priority[:regex] === item
      end

      weights = priorities.map do |priority|
        priority[:weight]
      end
    end
 end

  Resque::Worker.send(:include, Fairly)
end
