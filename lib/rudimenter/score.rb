module Rudimenter
  class Score
    attr_reader :measures

    def initialize
      @measures = []
    end

    def add_measure(measure)
      @measures << measure
    end
  end
end
