
When(/^I call the create function in the RefferalRewardController for event "([^"]*)"$/) do |event_title|
  @event = Event.find_by(title: event_title)
  post "/api/v1/events/1/referral_summary?reward=50"
end

When(/^I call the create function again in the RefferalRewardController for event "([^"]*)"$/) do |event_title|
  event = Event.find_by(title: event_title)
  post "/api/v1/events/1/referral_summary?reward=100"
  
end

Then(/^I should get a new Referral Reward for the event "([^"]*)" in the database$/) do |event_title|
  # code to check if a new referral reward was created for the given event title
  event = Event.find_by(title: event_title)
  reward = ReferralReward.find_by(event_id: event.id)
  expect(reward.reward).to eq("50")
end

Then(/^the referral reward for the event "([^"]*)" should be updated in the database$/) do |event_title|
  # code to check if the referral reward for the given event title was updated
  event = Event.find_by(title: event_title)
  reward = ReferralReward.find_by(event_id: event.id)
  expect(reward.reward).to eq("100")
end
