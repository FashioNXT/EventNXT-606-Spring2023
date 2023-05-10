require 'rails_helper'

RSpec.describe "show edit and destroy options", type: :view do
  before(:each) do

    user1 = User.create!(first_name: 'Casey', last_name: 'Quinn', email: 'user@example.com', password: 'password') 
    datetime1 = DateTime.new(2024, 9, 1, 8, 0, 0)
    event1 = Event.create!(id: 10, title: 'fake_title', datetime: datetime1, address: '107 Knox Dr', description: 'Test Description', user: user1) 

    @seat = assign(:seat, Seat.create!(
        :category => 'a',
        :total_count => 20,
        :event_id => 10
    ))
  end
  it "renders a list of seats" do
    render @seat
    assert_select "div>a", :text => "Edit".to_s, :count => 1
    assert_select "div>a", :text => "Destroy".to_s, :count => 1
  end
end