require "rails_helper"

RSpec.describe Api::V1::BoxofficeHeadersController, type: :controller do
    describe 'GET #index' do
      let!(:event) { create(:event) }
      let!(:header1) { create(:boxoffice_header, event_id: event.id) }
      let!(:header2) { create(:boxoffice_header, event_id: event.id) }
  
      it 'returns a successful response' do
        get :index, params: { event_id: event.id }
        expect(response).to be_successful
      end
  
      it 'returns the headers for the specified event' do
        get :index, params: { event_id: event.id }
        expect(JSON.parse(response.body)).to eq([header1.as_json, header2.as_json])
      end
    end

    describe 'GET #header_names' do
      let(:event_id) { 1 }
      let!(:boxoffice_headers) { create_list(:boxoffice_header, 3, event_id: event_id) }
  
      it 'returns the header names as JSON' do
        get :header_names, params: { event_id: event_id }
  
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
  
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.size).to eq(3)
        expect(parsed_response).to match_array(boxoffice_headers.pluck(:name))
      end
    end
  end
  