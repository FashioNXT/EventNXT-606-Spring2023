require 'rails_helper'

RSpec.describe "seating_types/show", type: :view do
  before(:each) do
    @seating_type = assign(:seating_type, Seat.create!(
      :category => "Seat Category",
      :total_count => 2,
      :event => 10
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Seat Category/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/10/)
  end
end
