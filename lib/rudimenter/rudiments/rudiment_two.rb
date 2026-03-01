module Rudimenter
  module Rudiments
    class RudimentTwo
      def generate
        score = Score.new

        progression.each_with_index do |(root, pattern), index|
          harmony = Harmony.new(root: root, kind: "dominant")
          measure = Measure.new(number: index + 1, harmony: harmony)

          pattern.each_with_index do |note_data, i|
            if i == 0
              # Beat 1 becomes two eighth notes
              measure.add_note(
                NoteEvent.new(
                  step: note_data[:step],
                  octave: note_data[:octave],
                  string: note_data[:string],
                  fret: note_data[:fret],
                  alter: note_data[:alter] || 0,
                  duration: 1
                )
              )

              # 1& harmony (stacked)
              high_string_notes(root).each_with_index do |high_note, idx|
                measure.add_note(
                  NoteEvent.new(
                    step: high_note[:step],
                    octave: high_note[:octave],
                    string: high_note[:string],
                    fret: high_note[:fret],
                    alter: high_note[:alter] || 0,
                    duration: 1,
                    chord: idx > 0
                  )
                )
              end
            else
              # Beats 2–4 unchanged quarter notes
              measure.add_note(
                NoteEvent.new(
                  step: note_data[:step],
                  octave: note_data[:octave],
                  string: note_data[:string],
                  fret: note_data[:fret],
                  alter: note_data[:alter] || 0,
                  duration: 2
                )
              )
            end
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

      def high_string_notes(root)
        case root
        when "E"
          [
            { step: "E", octave: 4, string: 1, fret: 0 },
            { step: "B", octave: 3, string: 2, fret: 0 }
          ]
        when "A"
          [
            { step: "E", octave: 4, string: 1, fret: 3 },
            { step: "C", alter: 1, octave: 4, string: 2, fret: 2 }
          ]
        when "B"
          [
            { step: "F", alter: 1, octave: 4, string: 1, fret: 2 }, # F#
            { step: "B", octave: 3, string: 2, fret: 0 }            # B (open)
          ]
        else
          []
        end
      end

      # Bass patterns stay quarter notes
      def e7_pattern
        [
          { step: "E", octave: 2, string: 6, fret: 0 },
          { step: "E", octave: 3, string: 4, fret: 2 },
          { step: "B", octave: 2, string: 5, fret: 2 },
          { step: "E", octave: 3, string: 4, fret: 2 }
        ]
      end

      def a7_pattern
        [
          { step: "A", octave: 2, string: 5, fret: 0 },
          { step: "E", octave: 3, string: 4, fret: 2 },
          { step: "E", octave: 2, string: 6, fret: 0 },
          { step: "E", octave: 3, string: 4, fret: 2 }
        ]
      end

      def b7_pattern
        [
          { step: "B", octave: 2, string: 5, fret: 2 },
          { step: "D", alter: 1, octave: 3, string: 4, fret: 1 },
          { step: "F", alter: 1, octave: 2, string: 6, fret: 2 },
          { step: "D", alter: 1, octave: 3, string: 4, fret: 1 }
        ]
      end
    end
  end
end
