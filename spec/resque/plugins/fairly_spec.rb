require File.expand_path("../../spec_helper", File.dirname(__FILE__))

describe Resque::Plugins::Fairly do
  it "changes Resque::Worker#queues to return queues in a random order (rand seeded w/ 2)" do
    worker = Resque::Worker.new('a','b')

    srand(2) 
    worker.queues.should == ['a', 'b']
  end

  it "changes Resque::Worker#queues to return queues in a random order (rand seeded w/ 1)" do
    worker = Resque::Worker.new('a','b')

    srand(1)
    worker.queues.should == ['b', 'a']
  end

  it "changes Resque::Worker#queues to return queues in a weighted random order" do
    worker = Resque::Worker.new('a','b')
    Resque::Plugins::Fairly.prioritize(/a/, 2)

    as, bs = [], []
    1.upto 100 do 
      arr = worker.queues
      as << arr if arr.first == 'a'
      bs << arr if arr.first == 'b'
    end

    as.size.should == 66
    bs.size.should == 34
  end

  it "changes Resque::Worker#queues to return queues with zero weight matches eliminated" do
    worker = Resque::Worker.new('a','b','c')
    Resque::Plugins::Fairly.prioritize(/c/, 0)

    worker.queues.include?('c').should == false
  end
end
