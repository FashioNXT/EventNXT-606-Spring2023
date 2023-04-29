# In your Cucumber step definition file

Given(/^the following events exist:$/) do |table|
  # Parse the events table and create events in the database
  table.hashes.each do |event_hash|
    @event = Event.create!(title: event_hash['title'], address: event_hash['address'], datetime: event_hash['datetime'], description: event_hash['description'])
  end
end

Given(/^the following user exist:$/) do |table|
  # Parse the guests table and create guests in the database
  table.hashes.each do |guest_hash|
    @user = User.create!(id: guest_hash['id'], encrypted_password: guest_hash['encrypted_password'], password: guest_hash['password'], email: guest_hash['email'], first_name: guest_hash['first_name'], last_name: guest_hash['last_name'], created_at: guest_hash['created_at'], updated_at: guest_hash['updated_at'])
  end
end

Given(/^the following guests exist:$/) do |table|
  # Parse the guests table and create guests in the database
  table.hashes.each do |guest_hash|
    @event = Event.find_by(id: guest_hash['event_id'])
    if @event
      Guest.create!(event_id: guest_hash['event_id'], added_by: guest_hash['added_by'], email: guest_hash['email'], first_name: guest_hash['first_name'], last_name: guest_hash['last_name'], affiliation: guest_hash['affiliation'], booked: guest_hash['booked'], invite_expiration: guest_hash['invite_expiration'], referral_expiration: guest_hash['referral_expiration'], invited_at: guest_hash['invited_at'], emailed_at: guest_hash['emailed_at'], checked: guest_hash['checked'], guestcommitted: guest_hash['guestcommitted'], perks: guest_hash['perks'], comments: guest_hash['comments'])
    else
      raise "Event with ID #{guest_hash['event_id']} not found"
    end
    
    #event = Event.find_by(title: guest_hash['event_title'])
    #if event
    #  Guest.create!(added_by: guest_hash['added_by'], email: guest_hash['email'], first_name: guest_hash['first_name'], last_name: guest_hash['last_name'], affiliation: guest_hash['affiliation'], type: guest_hash['type'], booked: guest_hash['booked'], invite_expiration: guest_hash['invite_expiration'], referral_expiration: guest_hash['referral_expiration'], invited_at: guest_hash['invited_at'], emailed_at: guest_hash['emailed_at'], checked: guest_hash['checked'], guestcommitted: guest_hash['guestcommitted'], perks: guest_hash['perks'], comments: guest_hash['comments'])
    #else
    #  raise "Event with title #{guest_hash['event_title']} not found"
    #end

    
  end
end



Given(/^I am on the show page for "([^"]*)"$/) do |category|
  # Implementation for navigating to the show page for the given category
  visit event_path(Event.where(:title => category).pluck(:id)[0])
end


And(/^I send a "Referral Invitation" email with the following params:$/) do |params_table|
  # Convert the Cucumber table to a hash of params
  email_params = params_table.rows_hash

  # Make a POST request to the EmailController#create action
  @response = post '/api/v1/email', params: email_params
end

Then(/^I should get confirmation that the email was sent$/) do
  # Assert that the response has a successful status code
  #expect(@response).to have_http_status(:ok)
  expect(@response).to be_successful
end


When(/^I go to the purchase page for guest "([^"]*)" referred by "([^"]*)" for event "([^"]*)"$/) do |guestEmail, referrerName, eventName|
  # Code to navigate to the purchase page for the given guest email and referrer name
  @event = Event.find_by(:title => eventName)
  f_name = referrerName.split[0]
  l_name = referrerName.split[1]
  @guest = Guest.find_by(first_name: f_name, last_name: l_name, event_id: @event.id)
  #visit "/purchase?guest_email=#{guest_email}&referrer_name=#{referrer_name}"
  visit "/events/#{@event.id}/purchase?token=#{@guest.id}&referee=#{guestEmail}"
end

Then(/^the database should contain the referral for guest "([^"]*)"$/) do |guestEmail|
  # Code to verify that the referral information is added to the database
  @ref = GuestReferral.where(email: guestEmail)
  puts @ref
  expect(GuestReferral.find_by(event: @event.id, email: guestEmail)).to_not be_nil
end

Then(/^the database should not contain the referral$/) do
  # Code to verify that the referral information is not added to the database
  # Example: expect(Referral.find_by(referral_code: 'some_referral_code')).to be_nil
end

And(/^I click "([^"]*)"$/) do |button_text|
  click_button button_text
end


Then(/^I should see "([^"]*)"$/) do |message|
  # Implementation for verifying the presence of the given message on the page
  # Example: expect(page).to have_content message
end

Then(/^the referral_rewards table should contain a reward for event "([^"]*)"$/) do |eventName|
  # Code to verify that the referral information is added to the database
  event = Event.find_by(:title => eventName)
  puts event
  expect(ReferralReward.find_by(event: event.id)).to_not be_nil
end











