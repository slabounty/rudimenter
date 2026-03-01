# spec/support/rudiment_contract.rb

RSpec.shared_examples "a 4/4 rudiment" do
  it "totals exactly one 4/4 measure per bar" do
    score.measures.each do |measure|
      total = measure.notes.reject(&:chord).sum(&:duration)
      expect(total).to eq(8)
    end
  end
end
