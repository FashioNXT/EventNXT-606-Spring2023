Feature: 
  I want to send an email to a guest through which they can send a referral link to another guest

Feature: allow guest to refer another guest

  As an event owner 
  I want to send referral invitation email with referral link to a specific VIP guest
  So that they can get referral rewards if a referred guest purchases tickets
  
Background: guests of an event in database

  Given the following events exist:
    | id        | title    | address          | datetime       | description |
    | 1         | Fashion  | 123 Main St      | 10/01/2024     | A fashion event |
  
  Given the following user exist:
    | id        | email             | encrypted_password | first_name | last_name | created_at | updated_at | password |
    | 1        | vaibhavbajaj96@gmail.com     | password | Vaibhav    | Bajaj     | 10/05/2023 | 10/05/2023 | password |
  
  
Scenario: modifying the referral reward should lead to the creation of a referral reward and consequently updating it
  When I call the create function in the RefferalRewardController for event "Fashion"
  Then I should get a new Referral Reward for the event "Fashion" in the database
  When I call the create function again in the RefferalRewardController for event "Fashion"
  Then the referral reward for the event "Fashion" should be updated in the database
    
