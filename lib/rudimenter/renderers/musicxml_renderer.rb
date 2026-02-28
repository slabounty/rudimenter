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
          # Only first measure gets attributes
          render_attributes(xml) if measure.number == 1

          render_harmony(xml, measure.harmony)

          measure.notes.each do |note_event|
            render_note(xml, note_event)
          end
        end
      end

      def render_attributes(xml)
        xml.attributes do
          xml.divisions 2   # eighth = 1, quarter = 2

          xml.key do
            xml.fifths 4
            xml.mode "major"
          end

          xml.time do
            xml.beats 4
            xml.send("beat-type", 4)
          end

          xml.staves 2

          # Standard notation staff
          xml.clef(number: 1) do
            xml.sign "G"
            xml.line 2
            xml.send("clef-octave-change", -1)
          end

          # TAB staff
          xml.clef(number: 2) do
            xml.sign "TAB"
            xml.line 5
          end

          # REQUIRED for TAB
          xml.staff_details(number: 2) do
            xml.staff_lines 6

            [
              ["E", 2],
              ["A", 2],
              ["D", 3],
              ["G", 3],
              ["B", 3],
              ["E", 4]
            ].each_with_index do |(step, octave), i|
              xml.staff_tuning(line: i + 1) do
                xml.tuning_step step
                xml.tuning_octave octave
              end
            end
          end
        end
      end

      def render_harmony(xml, harmony)
        xml.harmony do
          xml.root do
            xml.send("root-step", harmony.root)
          end
          # show "7" explicitly
          xml.kind "dominant", text: "7"
        end
      end

      def render_note(xml, note_event)
        xml.note do
          xml.chord if note_event.respond_to?(:chord) && note_event.chord

          xml.pitch do
            xml.step note_event.step
            xml.alter note_event.alter if note_event.alter != 0
            xml.octave note_event.octave
          end

          xml.duration note_event.duration
          xml.voice 1
          xml.type note_type_from_duration(note_event.duration)
          xml.staff 1
        end

        # TAB note (same pitch, different staff)
        xml.note do
          xml.chord if note_event.respond_to?(:chord) && note_event.chord

          xml.pitch do
            xml.step note_event.step
            xml.alter note_event.alter if note_event.alter != 0
            xml.octave note_event.octave
          end

          xml.duration note_event.duration
          xml.voice 1
          xml.type note_type_from_duration(note_event.duration)
          xml.staff 2

          xml.notations do
            xml.technical do
              xml.string note_event.string
              xml.fret note_event.fret
            end
          end
        end
      end
      def note_type_from_duration(duration)
        case duration
        when 1 then "eighth"
        when 2 then "quarter"
        when 4 then "half"
        when 8 then "whole"
        else
          "eighth" # safe default
        end
      end
    end
  end
end
