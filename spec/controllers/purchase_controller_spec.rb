require 'rails_helper'

RSpec.describe PurchasesController, type: :controller do
  describe 'GET #show' do
    let(:event_id) { 1 }
    let(:token) { 'example_token' }
    let(:referee) { 'example_referee' }

    context 'when token parameter is present' do
      before do
        get :show, params: { event_id: event_id, token: token, referee: referee }
      end

      it 'renders the show template' do
        expect(response).to render_template(:show)
      end

      it 'assigns the event_id, token, and referee instance variables' do
        expect(assigns(:event_id)).to eq(event_id)
        expect(assigns(:token)).to eq(token)
        expect(assigns(:referee)).to eq(referee)
      end
    end

    context 'when token parameter is not present' do
      before do
        get :show, params: { event_id: event_id, referee: referee }
      end

      it 'renders the not_found template' do
        expect(response).to render_template(:not_found)
      end
    end
  end
end
