require "rudimenter"

RSpec.describe Rudimenter::Rudiments::RudimentZero do
  let(:score) { described_class.new.generate }

  it_behaves_like "a 4/4 rudiment"

  it "creates 8 measures" do
    expect(score.measures.size).to eq(8)
  end

  it "each measure totals 8 divisions (4/4)" do
    score.measures.each do |measure|
      total = measure.notes.reject(&:chord).sum(&:duration)
      expect(total).to eq(8)
    end
  end

  it "does not contain any chord notes" do
    score.measures.each do |measure|
      expect(measure.notes.any?(&:chord)).to be(false)
    end
  end
end
