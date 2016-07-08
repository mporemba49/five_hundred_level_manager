require 'rails_helper'

describe MensHoodie do
  let(:hoodie) { FactoryGirl.build(:mens_hoodie) }

  describe "attributes" do
    it "has the correct style" do
      expect(hoodie.style).to eq "Mens Hoodie"
    end

    it "is male" do
      expect(hoodie.gender).to eq "Male"
    end

    it "has the correct default price" do
      expect(hoodie.default_price).to eq 45
    end

    it "has the correct weight" do
      expect(hoodie.weight).to eq 908
    end
  end
end
