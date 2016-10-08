require 'rails_helper'

describe Clothing do
  let(:clothing) { FactoryGirl.build(:clothing) }

  describe "#set_handle_extension" do
    it "sets handle_extension to '-' by default" do
      expect{ clothing.save }.to change{clothing.handle_extension}.from("").to("-")
    end

    it "sets handle_extension to '-kids-' for kids clothing" do
      clothing.gender = 'Kids'
      expect{ clothing.save }.to change{clothing.handle_extension}.from("").to("-kids-")
    end

    describe "winter clothing" do
      let(:clothing) { FactoryGirl.build(:clothing, :winter) }

      it "sets handle_extension to '-WINTER'" do
        expect{ clothing.save }.to change{clothing.handle_extension}.from("").to("-WINTER")
      end

      it "sets handle_extension to '-kids-WINTER' for kids clothing" do
        clothing.gender = 'Kids'
        expect{ clothing.save }.to change{clothing.handle_extension}.from("").to("-kids-WINTER")
      end
    end
  end

  describe "#style_tag" do
    it "applies possessive gender to style for Non-gendered name" do
      expect(clothing.style_tag).to eq "Men's Cotton T-Shirt"
      clothing.gender = "Women"
      expect(clothing.style_tag).to eq "Women's Cotton T-Shirt"
      clothing.gender = "Kids"
      expect(clothing.style_tag).to eq "Kids Cotton T-Shirt"
    end

    it "returns style for gendered name clothing" do
      clothing.style = "Men's Cotton T-Shirt"
      expect(clothing.style_tag).to eq "Men's Cotton T-Shirt"
      clothing.style = "Women's Cotton T-Shirt"
      expect(clothing.style_tag).to eq "Women's Cotton T-Shirt"
      clothing.style = "Kids Cotton T-Shirt"
      expect(clothing.style_tag).to eq "Kids Cotton T-Shirt"
    end
  end

  describe "#img_alt_text(color)" do
    it "combines style with gender and color" do
      expect(clothing.img_alt_text('red')).to eq "Mens Cotton T-Shirt red"
      clothing.gender = 'Women'
      expect(clothing.img_alt_text('red')).to eq "Womens Cotton T-Shirt red"
      clothing.gender = 'Kids'
      expect(clothing.img_alt_text('red')).to eq "Kids Cotton T-Shirt red"
    end

    it "does not prepend gender if contained in style" do
      clothing.style = "Mens T-Shirt"
      expect(clothing.img_alt_text('red')).to eq "Mens T-Shirt red"
    end
  end
end
