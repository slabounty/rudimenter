module Rudimenter
  class NoteEvent
    attr_reader :step, :alter, :octave, :string, :fret, :duration

    def initialize(step:, octave:, string:, fret:, duration: 1, alter: 0)
      @step = step        # "E"
      @octave = octave    # 2
      @string = string    # 6
      @fret = fret        # 0
      @duration = duration
      @alter = alter      # 1 for sharp
    end
  end
end
