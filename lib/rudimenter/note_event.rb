class NoteEvent
  attr_reader :step, :alter, :octave, :string, :fret, :duration, :chord

  def initialize(step:, octave:, string:, fret:, alter: 0, duration: 1, chord: false)
    @step = step
    @alter = alter
    @octave = octave
    @string = string
    @fret = fret
    @duration = duration
    @chord = chord
  end
end
