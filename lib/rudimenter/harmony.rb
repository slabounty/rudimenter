module Rudimenter
  class Harmony
    attr_reader :root, :kind

    def initialize(root:, kind:)
      @root = root   # "E"
      @kind = kind   # "dominant"
    end
  end
end
