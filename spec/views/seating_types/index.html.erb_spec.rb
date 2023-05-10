require 'rails_helper'

RSpec.describe "seating_types/index", type: :view do
  before(:each) do
    assign(:seating_types, [
      Seat.create!(
        :seat_category => "Seat Category",
        :total_seat_count => 2,
        :vip_seat_count => 3,
        :box_office_seat_count => 4,
        :balance_seats => 5,
        :event => nil
      ),
      Seat.create!(
        :seat_category => "Seat Category",
        :total_seat_count => 2,
        :vip_seat_count => 3,
        :box_office_seat_count => 4,
        :balance_seats => 5,
        :event => nil
      )
    ])
  end

  it "renders a list of seating_types" do
    render
    assert_select "tr>td", :text => "Seat Category".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
