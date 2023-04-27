require 'rails_helper'


RSpec.describe GuestsController, type: :controller do
  describe "#new_guest" do
    it "renders the newimport template" do
      get :new_guest
      expect(response).to render_template("guests/newimport")
    end
  end

  describe "#import" do
    let(:guest_list) do
      [
        { "first_name" => "John", "last_name" => "Doe", "email" => "john.doe@example.com" },
        { "first_name" => "Jane", "last_name" => "Doe", "email" => "jane.doe@example.com" }
      ]
    end

    before do
      allow(GuestsImport).to receive(:new).and_return(double(add_guests: true))
    end

    context "with valid input parameters" do
      let(:event_id) { "1" }
      let(:api_key) { "123456" }
      let(:ticketing_website) { "Ticketmaster" }

      it "calls the add_guests method of GuestsImport" do
        expect(GuestsImport).to receive(:new).with(event_id: event_id, api_key: api_key).and_return(double(add_guests: true))
        post :import, params: { guests_import: { event_id: event_id, api_key: api_key, ticketing_website: ticketing_website } }
      end

      it "calls the API to get the guest list" do
        expect(Net::HTTP).to receive(:get_response).and_return(double(body: guest_list.to_json))
        post :import, params: { guests_import: { event_id: event_id, api_key: api_key, ticketing_website: ticketing_website } }
      end
    end

    context "with invalid ticketing_website parameter" do
      let(:event_id) { "1" }
      let(:api_key) { "123456" }
      let(:ticketing_website) { "Invalid" }

      it "redirects to the guests page with an alert message" do
        post :import, params: { guests_import: { event_id: event_id, api_key: api_key, ticketing_website: ticketing_website } }
        expect(response).to redirect_to(guests_path)
        expect(flash[:alert]).to eq("Invalid ticketing website")
      end
    end
    
     context "with valid input parameters for Eventbrite" do
      let(:event_id) { "1234567890" }
      let(:api_key) { "abcdefghijklmnopqrstuvwxyz" }
      let(:ticketing_website) { "Eventbrite" }

      it "calls the add_guests method of GuestsImport" do
        expect(GuestsImport).to receive(:new).with(event_id: event_id, api_key: api_key).and_return(double(add_guests: true))
        post :import, params: { guests_import: { event_id: event_id, api_key: api_key, ticketing_website: ticketing_website } }
      end

      it "calls the API to get the guest list" do
        uri = URI("https://www.eventbriteapi.com/v3/events/#{event_id}/attendees/")
        params = { 'token' => api_key }
        expect(Net::HTTP).to receive(:get_response).with(URI("#{uri}?#{URI.encode_www_form(params)}")).and_return(double(body: guest_list.to_json))
        post :import, params: { guests_import: { event_id: event_id, api_key: api_key, ticketing_website: ticketing_website } }
      end
    end

    context "with invalid ticketing_website parameter" do
      let(:event_id) { "1" }
      let(:api_key) { "123456" }
      let(:ticketing_website) { "Invalid" }

      it "redirects to the guests page with an alert message" do
        post :import, params: { guests_import: { event_id: event_id, api_key: api_key, ticketing_website: ticketing_website } }
        expect(response).to redirect_to(guests_path)
        expect(flash[:alert]).to eq("Invalid ticketing website")
      end
    end
    
  end
end

