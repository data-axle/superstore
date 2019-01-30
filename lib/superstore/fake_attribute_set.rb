module Superstore
  class FakeAttributeSet < Hash
    def reset(key)
      delete(key)
    end
  end
end
