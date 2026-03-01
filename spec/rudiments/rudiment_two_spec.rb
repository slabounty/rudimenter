require "spec_helper"

RSpec.describe Rudimenter::Rudiments::RudimentTwo do
  subject(:score) { described_class.new.generate }

  it_behaves_like "a 4/4 rudiment"

  it "splits beat 1 into two eighth notes" do
    score.measures.each do |measure|
      first_note = measure.notes.first
      second_note = measure.notes[1]

      expect(first_note.duration).to eq(1)
      expect(second_note.duration).to eq(1)
    end
  end

  it "stacks harmony only on the and of one (1&)" do
    score.measures.each do |measure|
      # First note = bass (not chord)
      expect(measure.notes[0].chord).to be(false)

      # Next two notes = stacked harmony
      expect(measure.notes[1].chord).to be(false) # first harmony note
      expect(measure.notes[2].chord).to be(true)  # stacked note

      # No more harmony after index 2
      remaining = measure.notes[3..] || []
      expect(remaining.any?(&:chord)).to be(false)
    end
  end

  it "keeps beats 2, 3, and 4 as quarter notes" do
    score.measures.each do |measure|
      # Notes after the harmony stack
      bass_notes = measure.notes[3..] || []

      bass_notes.each do |note|
        expect(note.duration).to eq(2)
      end
    end
  end

  it "contains exactly 4 time-advancing bass notes per measure" do
    score.measures.each do |measure|
      advancing_notes = measure.notes.reject(&:chord)
      total_duration = advancing_notes.sum(&:duration)

      expect(total_duration).to eq(8)
    end
  end
end
