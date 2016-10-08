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

  describe "#add_sizes" do
    let(:clothing) { FactoryGirl.create(:clothing) }
    let(:small_size) { FactoryGirl.create(:size) }
    let(:med_size) { FactoryGirl.create(:size, :medium) }

    it "adds a size for the clothing" do
      expect{
        clothing.add_sizes([small_size.name, med_size.name])
      }.to change{ ClothingSize.count }.by(2)
    end

    it "deletes existing sizes before refreshing" do
      clothing.add_sizes([small_size.name, med_size.name])
      expect(clothing.sizes.count).to eq 2
      expect{
        clothing.add_sizes([small_size.name])
      }.to change{ ClothingSize.count }.by(-1)
      expect(clothing.sizes.first.name).to eq 'S'
    end
  end

  describe "#csv_lines_for_color" do
    let(:small_size) { FactoryGirl.create(:size) }
    let(:med_size) { FactoryGirl.create(:size, :medium) }
    let(:clothing) { FactoryGirl.create(:clothing) }

    before do
      clothing.add_sizes([small_size.name, med_size.name])
      color = FactoryGirl.create(:color)
      @clothing_color = ClothingColor.create(clothing: clothing, color: color, image: 'Men-Eco-Grey-Alternative-V-Neck-Tee.jpg')
    end

    it "creates a line for each size" do
      found_path = double(key: "NFL/Minnesota Vikings/Matt Asiata Football P/Men/Men-Eco-Grey-Alternative-V-Neck-Tee.jpg")
      allow(Validator).to receive(:objects).and_return([found_path])
      CreateDesigns.call("spec/fixtures/title_team_player.csv") 
      input_entry = InputEntry.new('mattasiatafootballp', 'Matt Asiata Football P', 'Nicole Marie')
      clothing.entry = input_entry
      expect(clothing.csv_lines_for_color(@clothing_color, true).count).to eq 2
    end
  end

  describe "#full_sku" do
    it "creates a unique sku" do
      found_path = double(key: "NFL/Minnesota Vikings/Matt Asiata Football P/Men/Men-Eco-Grey-Alternative-V-Neck-Tee.jpg")
      allow(Validator).to receive(:objects).and_return([found_path])
      CreateDesigns.call("spec/fixtures/title_team_player.csv") 
      input_entry = InputEntry.new('mattasiatafootballp', 'Matt Asiata Football P', 'Nicole Marie')
      clothing.entry = input_entry
      size = FactoryGirl.create(:size)
      clothing.add_sizes([size.name])
      color = FactoryGirl.create(:color)
      clothing_color = ClothingColor.create(clothing: clothing, color: color, image: 'Men-Eco-Grey-Alternative-V-Neck-Tee.jpg')
      clothing.royalty_sku = "FOO"
      sku = clothing.full_sku(size, clothing_color).first
      expect(sku.include?('FOO')).to be true
    end
  end
end
