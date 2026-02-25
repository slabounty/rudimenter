module Rudimenter
  class Measure
    attr_reader :number, :harmony, :notes

    def initialize(number:, harmony:)
      @number = number
      @harmony = harmony
      @notes = []
    end

    def add_note(note)
      @notes << note
    end
  end
end
