module Rudimenter
  module Rudiments
    class RudimentZero
      def generate
        score = Score.new

        progression.each_with_index do |(root, pattern), index|
          harmony = Harmony.new(root: root, kind: "dominant")
          measure = Measure.new(number: index + 1, harmony: harmony)

          pattern.each do |note_data|
            measure.add_note(
              NoteEvent.new(
                step: note_data[:step],
                octave: note_data[:octave],
                string: note_data[:string],
                fret: note_data[:fret],
                alter: note_data[:alter] || 0,
                duration: note_data[:duration] || 1
              )
            )
          end

          score.add_measure(measure)
        end

        score
      end

      private

      def progression
        [
          ["E", e7_pattern],
          ["E", e7_pattern],
          ["A", a7_pattern],
          ["A", a7_pattern],
          ["B", b7_pattern],
          ["B", b7_pattern],
          ["E", e7_pattern],
          ["E", e7_pattern]
        ]
      end

      def e7_pattern
        [
          { step: "E", octave: 2, string: 6, fret: 0, duration: 2 },
          { step: "E", octave: 3, string: 4, fret: 2, duration: 2 },
          { step: "B", octave: 2, string: 5, fret: 2, duration: 2 },
          { step: "E", octave: 3, string: 4, fret: 2, duration: 2 }
        ]
      end

      def a7_pattern
        [
          { step: "A", octave: 2, string: 5, fret: 0, duration: 2 },
          { step: "E", octave: 3, string: 4, fret: 2, duration: 2 },
          { step: "E", octave: 2, string: 6, fret: 0, duration: 2 },
          { step: "E", octave: 3, string: 4, fret: 2, duration: 2 }
        ]
      end

      def b7_pattern
        [
          { step: "B", octave: 2, string: 5, fret: 2, duration: 2 },
          { step: "D", alter: 1, octave: 3, string: 4, fret: 1, duration: 2 },
          { step: "F", alter: 1, octave: 2, string: 6, fret: 2, duration: 2 },
          { step: "D", alter: 1, octave: 3, string: 4, fret: 1, duration: 2 }
        ]
      end
    end
  end
end
