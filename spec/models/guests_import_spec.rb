require 'rails_helper'

RSpec.describe GuestsImport, type: :model do
  context 'with Ticketmaster' do
    subject(:guests_import) { described_class.new(event_id: '2000527EE48A9334', api_key: 'HAuyG5PbQX71SLAVgAzc2KtVPwaJrXNe', ticketing_website: 'http://www.ticketmaster_or_eventbrite.com') }

    describe '#valid?' do
      context 'when event_id and api_key are present' do
        it 'returns true' do
          expect(guests_import.valid?).to be true
        end
      end

      context 'when event_id is missing' do
        before { guests_import.event_id = nil }

        it 'returns false' do
          expect(guests_import.valid?).to be false
        end
      end

      context 'when api_key is missing' do
        before { guests_import.api_key = nil }

        it 'returns false' do
          expect(guests_import.valid?).to be false
        end
      end
    end

    describe '#add_guests' do
      let(:guest_list) { [{ 'first_name' => 'John', 'last_name' => 'Doe', 'email' => 'john@example.com' }] }

      it 'creates and saves guests with correct event_id' do
        expect(Guest).to receive(:new_guest).with(hash_including(event_id: guests_import.event_id)).and_return(instance_double('Guest', save: true))
        guests_import.add_guests(guest_list)
      end
    end
  end

  
end
