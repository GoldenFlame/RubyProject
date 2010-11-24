module Matchers
  class BeLoadedWith
    def initialize(expected)
      @expected = expected
    end
    def matches?(actual)
      updated = true
      @expected.each{|k,v| if(actual.instance_variable_get(:"@#{k}") != v) then updated = false; puts "#{k}:#{v}" end}
      updated
    end

    def failure_message
      "expected to have provided values but does not.'"
    end

    def negative_failure_message
      "expected not have provided values but does.'"
    end
  end

  def be_loaded_with(expected)
    BeLoadedWith.new(expected)
  end
end