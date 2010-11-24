module Matchers
  class HaveHashValues
    def initialize(expected)
      @expected = expected
    end
    def matches?(actual)
      status = true
      @expected.each{|k,v| if(actual[k] != v) then status = false end}
      status
    end

    def failure_message
      "expected to have provided hash values but does not.'"
    end

    def negative_failure_message
      "expected not have provided hash values but does.'"
    end
  end

  def have_hash_values(expected)
    HaveHashValues.new(expected)
  end
end