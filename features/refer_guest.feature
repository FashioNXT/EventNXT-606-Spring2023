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
    
  Given the following guests exist:
    | event_id  | id    | event_title | added_by | email             | first_name | last_name | affiliation | type | booked | invite_expiration | referral_expiration | invited_at | emailed_at | checked | guestcommitted | perks | comments |
    | 1         | 1     | Fashion     | 1        | sim@gmail.com     | Sim        | Amy       | Guest        | R1   | true   | 10/02/2024        | 10/03/2024          | 10/01/2024 | 10/01/2024 | false   | 1              | VIP   | "Special guest" |
    | 1         | 2     | Fashion     | 1        | join@gmail.com    | Holmes     | Join      | Affiliate    | R2   | false  |                   |                      |            |            | false    | 0              |       |               |

  

Scenario: confirm that referral information is added to the database when a referred guest first clicks on a referral link
  When I go to the purchase page for guest "join@gmail.com" referred by "Sim Amy" for event "Fashion"
  And I click "Purchase"
  Then the database should contain the referral for guest "join@gmail.com"
  When I go to the purchase page for guest "join@gmail.com" referred by "Holmes Join"
  And I click "Purchase"
  Then the database should not contain the referral
  
  
Scenario: send referral invitation to existing VIP guest
  Given I am on the show page for "Fashion"
  And I send a "Referral Invitation" email with the following params:
    | senders | "vaibhavwaste96@gmail.com" |
    | recipients | "vaibhavwaste96@gmail.com" |
    | template_id | 24 |
    | event_id | 1 |
  Then I should get confirmation that the email was sent
 
    
