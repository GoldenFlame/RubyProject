module Matchers
  class BeUpdated
    def initialize(expected)
      @expected = expected
    end
    def matches?(actual)
      if(@expected.eql?(actual))
        false
      else 
        true
      end
    end

    def failure_message
      "expected to be readable but is not.'"
    end

    def negative_failure_message
      "expected not to be readable but did.'"
    end
  end

  def be_updated(expected)
    BeUpdated.new(expected)
  end
end