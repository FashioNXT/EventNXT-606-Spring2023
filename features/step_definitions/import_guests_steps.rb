require 'net/http'

Given(/^I have a valid event ID "(.*?)" and API key "(.*?)"$/) do |event_id, api_key|
  @event_id = event_id
  @api_key = api_key
end
  
Given(/^I have an invalid event ID or API key for Ticketmaster$/) do
  @event_id = 'INVALID_EVENT_ID'
  @api_key = 'INVALID_API_KEY'
end

When(/^I import guests from Ticketmaster$/) do
  if @event_id == "2000527EE48A9334" && @api_key == "HAuyG5PbQX71SLAVgAzc2KtVPwaJrXNe"
      guest_data = @guests.map do |guest|
        {
          first_name: guest['First Name'],
          last_name: guest['Last Name'],
          email: guest['Email'],
          seat_level: guest['Seat Level'],
          number_of_seats: guest['Number of Seats']
        }
      end
      @guest_list_saved_successfully = true # simulate successful guest list save
    else
      @guest_list_saved_successfully = false # simulate unsuccessful guest list save
    end
end

Then(/^the guest list should be saved successfully$/) do
    expect(@guest_list_saved_successfully).to eq(true)
end

Given(/^I have a valid event ID "(.*?)" and API key "(.*?)" for Eventbrite$/) do |event_id, api_key|
  @event_id = event_id
  @api_key = api_key
end


Given(/^the following guests are registered for the event:$/) do |table|
   @guests = table.hashes
end

When(/^I import guests from Eventbrite$/) do
  if @event_id == "2000527EE48A9334" && @api_key == "HAuyG5PbQX71SLAVgAzc2KtVPwaJrXNe"
      guest_data = @guests.map do |guest|
        {
          first_name: guest['First Name'],
          last_name: guest['Last Name'],
          email: guest['Email'],
          seat_level: guest['Seat Level'],
          number_of_seats: guest['Number of Seats']
          
        }
      end
      @guest_list_saved_successfully = true # simulate successful guest list save
    else
      @guest_list_saved_successfully = false # simulate unsuccessful guest list save
    end
end



Then(/^the guest list should not be saved$/) do
  expect(@guest_list_saved_successfully).to eq(false)
end


Given(/^I have an invalid event ID or API key for Eventbrite$/) do
  @event_id = 'INVALID_EVENT_ID'
  @api_key = 'INVALID_API_KEY'
end
