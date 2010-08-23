require File.expand_path("../../spec_helper", File.dirname(__FILE__))

describe Resque::Plugins::Fairly do
  it "changes Resque::Worker#queues to return queues in a random order (rand seeded w/ 2" do
    worker = Resque::Worker.new('a','b')

    srand(2) 
    worker.queues.should == ['b', 'a']
  end

  it "changes Resque::Worker#queues to return queues in a random order (rand seeded w/ 1" do
    worker = Resque::Worker.new('a','b')

    srand(1)
    worker.queues.should == ['a', 'b']
  end

end
