module Matchers
  class BeUpdated
    def initialize(expected)
      @expected = expected
    end
    def matches?(actual)
      updated = false
      actual.each{|k,v| if(@expected[k] != v) then updated = true end}
      updated
    end

    def failure_message
      "expected to be updated but is not.'"
    end

    def negative_failure_message
      "expected not to be updated but is.'"
    end
  end

  def be_updated(expected)
    BeUpdated.new(expected)
  end
end