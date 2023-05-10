require 'rails_helper'

RSpec.describe Guest, type: :model do
  it "fails without email" do
    guest = build(:guest, email: nil)
    expect(guest).to_not be_valid
  end

  it "fails if invite expiration has already passed" do
    guest = build(:guest, invite_expiration: Faker::Date.backward)
    expect(guest).to_not be_valid
  end

  it "fails if referral expiration has already passed" do
    guest = build(:guest, referral_expiration: Faker::Date.backward)
    expect(guest).to_not be_valid
  end

  it "sets the booked status even if booked is not set" do
    user = build :user, id: 1
    event = build :event, id: 1, user: user
    guest = build :guest, event: event, user: user, booked: nil
    expect(guest).to be_valid
  end

  it "has a valid model with at least email, booked status, and added_by" do
    user = build :user, id: 1
    event = build :event, id: 1, user: user

    g_attr = attributes_for(:guest).except(:first_name, :last_name, :invite_expiration, :referral_expiration, :invited_at)
    guest = build :guest, event: event, user: user, **g_attr
    expect(guest).to be_valid
  end

  describe '.import_guests_csv' do
    let(:file_path) { 'path/to/csv/file.csv' }
    let(:event) { create(:event) }

    before do
      # Create a sample CSV file with headers and data
      CSV.open(file_path, 'wb', headers: true, header_converters: :symbol) do |csv|
        csv << %i[first_name last_name email]
        csv << ['John', 'Doe', 'john.doe@example.com']
        csv << ['Jane', 'Smith', 'jane.smith@example.com']
      end
    end

    after do
      # Delete the sample CSV file
      File.delete(file_path) if File.exist?(file_path)
    end

    it 'imports guests from a CSV file' do
      expect do
        Guest.import_guests_csv(File.open(file_path), event)
      end.to change(Guest, :count).by(2)

      john_doe = Guest.find_by(email: 'john.doe@example.com')
      jane_smith = Guest.find_by(email: 'jane.smith@example.com')

      expect(john_doe).to have_attributes(
        first_name: 'John',
        last_name: 'Doe',
        email: 'john.doe@example.com',
        added_by: event.user.id,
        event_id: event.id
      )

      expect(jane_smith).to have_attributes(
        first_name: 'Jane',
        last_name: 'Smith',
        email: 'jane.smith@example.com',
        added_by: event.user.id,
        event_id: event.id
      )
    end
  end
end
