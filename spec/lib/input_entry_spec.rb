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

  describe "#url_string_for_clothing" do
    let!(:clothing) { FactoryGirl.create(:clothing) }

    before do
      found_path = double(key: "NFL/Minnesota Vikings/Matt Asiata Football P/Men/Men-Eco-Grey-Alternative-V-Neck-Tee.jpg")
      allow(Validator).to receive(:objects).and_return([found_path])
    end

    it "returns URL for clothing image" do
      expect(@input_entry.url_string_for_clothing(clothing, "Men-Eco-Grey-Alternative-V-Neck-Tee.jpg")).to eq "https://images.com/NFL/Minnesota%20Vikings/Matt%20Asiata%20Football%20P/Men/Men-Eco-Grey-Alternative-V-Neck-Tee.jpg"
    end

    it "returns nil when no match exists" do
      expect(@input_entry.url_string_for_clothing(clothing, "foo.png")).to be_nil
    end
  end

  describe "#tags" do
    let!(:clothing) { FactoryGirl.create(:clothing) }

    it "returns proper tags when first_line" do
      tags = ["Matt Asiata Football P",
              nil,
              "Nicole Marie",
              "T-Shirt",
              "player=Matt Asiata,gender=men,style=Men's Cotton T-Shirt,v=2,team=Minnesota Vikings,city=Minnesota,sport=Football",
              true]
      expect(@input_entry.tags(clothing, true, true)).to eq tags
    end

    it "returns nil tags when not first line" do
      tags = [nil,nil,nil,nil,nil,nil]
      expect(@input_entry.tags(clothing, true, false)).to eq tags
    end
  end
end
