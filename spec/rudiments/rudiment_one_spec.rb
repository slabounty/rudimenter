require "rudimenter"

RSpec.describe Rudimenter::Rudiments::RudimentOne do
  let(:score) { described_class.new.generate }

  it_behaves_like "a 4/4 rudiment"

  it "has exactly 4 time-advancing notes per measure" do
    score.measures.each do |measure|
      non_chord_notes = measure.notes.reject(&:chord)
      expect(non_chord_notes.size).to eq(4)
    end
  end

  it "has exactly 2 stacked harmony notes per measure" do
    score.measures.each do |measure|
      chord_notes = measure.notes.select(&:chord)
      expect(chord_notes.size).to eq(2)
    end
  end

  it "stacks harmony only on beat 1" do
    score.measures.each do |measure|
      # Expect notes 1 and 2 to be chord notes
      expect(measure.notes[1].chord).to be(true)
      expect(measure.notes[2].chord).to be(true)

      # Everything after index 2 should NOT be chord notes
      remaining_notes = measure.notes[3..] || []
      expect(remaining_notes.any?(&:chord)).to be(false)
    end
  end
end
