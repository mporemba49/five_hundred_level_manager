require 'rails_helper'

RSpec.describe "brands/show", type: :view do
  before(:each) do
    @brand = assign(:brand, Brand.create!(
      :name => "Name",
      :SKU => "Sku"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Sku/)
  end
end
