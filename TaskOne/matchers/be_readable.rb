module Matchers
  class BeReadable
    def matches?(actual)
      if(actual[:name] != nil) then
          true
      else 
        false
      end
    end

    def failure_message
      "expected to be readable but is not.'"
    end

    def negative_failure_message
      "expected not to be readable but did.'"
    end
  end

  def be_readable
    BeReadable.new
  end
end