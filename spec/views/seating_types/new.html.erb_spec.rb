require 'rails_helper'

RSpec.describe "seating_types/new", type: :view do
  before(:each) do
    assign(:seating_type, Seat.new(
      :seat_category => "MyString",
      :total_seat_count => 1,
      :vip_seat_count => 1,
      :box_office_seat_count => 1,
      :balance_seats => 1,
      :event => nil
    ))
  end

  it "renders new seating_type form" do
    render

    assert_select "form[action=?][method=?]", seating_types_path, "post" do

      assert_select "input[name=?]", "seating_type[seat_category]"

      assert_select "input[name=?]", "seating_type[total_seat_count]"

      assert_select "input[name=?]", "seating_type[vip_seat_count]"

      assert_select "input[name=?]", "seating_type[box_office_seat_count]"

      assert_select "input[name=?]", "seating_type[balance_seats]"

      assert_select "input[name=?]", "seating_type[event_id]"
    end
  end
end
