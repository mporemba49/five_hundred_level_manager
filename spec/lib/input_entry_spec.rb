require 'rails_helper'

describe InputEntry do
  before do
    CreateDesigns.call("spec/fixtures/title_team_player.csv") 
    @input_entry = InputEntry.new('mattasiatafootballp', 'Matt Asiata Football P', 'Nicole Marie')
  end

  describe "#url_design" do
    it "returns default path if found" do
      found_path = "NFL/Minnesota Vikings/Matt Asiata Football P/Men/"
      allow(Validator).to receive(:paths).and_return([found_path])
      expect(@input_entry.url_design).to eq "https://images.com/NFL/Minnesota Vikings/Matt Asiata Football P"
    end

    it "returns path with artist if found" do
      found_path = "NFL/Minnesota Vikings/Matt Asiata Football P (Nicole Marie)/Men/"
      allow(Validator).to receive(:paths).and_return([found_path])
      expect(@input_entry.url_design).to eq "https://images.com/NFL/Minnesota Vikings/Matt Asiata Football P (Nicole Marie)"
    end
  end
end
