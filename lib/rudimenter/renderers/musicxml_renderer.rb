require "nokogiri"

module Rudimenter
  module Renderers
    class MusicxmlRenderer
      def initialize(score)
        @score = score
      end

      def render
        body = Nokogiri::XML::Builder.new do |xml|
          xml.send("score-partwise", version: "4.0") do

            render_part_list(xml)

            xml.part(id: "P1") do
              @score.measures.each do |measure|
                render_measure(xml, measure)
              end
            end

          end
        end.to_xml

        <<~XML
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!DOCTYPE score-partwise PUBLIC
  "-//Recordare//DTD MusicXML 4.0 Partwise//EN"
  "http://www.musicxml.org/dtds/partwise.dtd">
#{body}
XML
      end

      private

      def render_part_list(xml)
        xml.send("part-list") do
          xml.send("score-part", id: "P1") do
            xml.send("part-name", "Guitar")
          end
        end
      end

      def render_measure(xml, measure)
        xml.measure(number: measure.number) do

          render_attributes(xml) if measure.number == 1
          render_harmony(xml, measure.harmony)

          measure.notes.each do |note|
            render_note(xml, note)
          end

        end
      end

      def render_attributes(xml)
        xml.attributes do
          xml.divisions 1

          xml.key do
            xml.fifths 4
            xml.mode "major"
          end

          xml.time do
            xml.beats 4
            xml.send("beat-type", 4)
          end

          # TWO STAVES
          xml.staves 2

          # Staff 1 - Standard notation
          xml.clef(number: 1) do
            xml.sign "G"
            xml.line 2
            xml.send("clef-octave-change", -1)
          end

          # Staff 2 - TAB
          xml.clef(number: 2) do
            xml.sign "TAB"
            xml.line 5
          end
        end
      end

      def render_harmony(xml, harmony)
        xml.harmony do
          xml.root do
            xml.send("root-step", harmony.root)
          end
          xml.kind "dominant", text: "7"
        end
      end

      def render_note(xml, note)
        # Staff 1 — Standard Notation
        xml.note do
          xml.pitch do
            xml.step note.step
            xml.alter note.alter if note.alter != 0
            xml.octave note.octave
          end
          xml.duration 1
          xml.type "quarter"
          xml.staff 1
        end

        # Staff 2 — TAB
        xml.note do
          xml.pitch do
            xml.step note.step
            xml.alter note.alter if note.alter != 0
            xml.octave note.octave
          end
          xml.duration 1
          xml.type "quarter"
          xml.staff 2

          xml.notations do
            xml.technical do
              xml.string note.string
              xml.fret note.fret
            end
          end
        end
      end
    end
  end
end
