require 'spec_helper'

RSpec.describe V1::StampsAPI, type: :request do
  # initialize test data
  let!(:stamps) { FactoryBot.create_list(:stamp, 10) }
  let(:stamp) { stamps.first }

  describe 'GET v1/stamps' do
    subject(:request) { get '/v1/stamps' }

    it 'returns stamps' do
      subject
      expect(json['stamps']).not_to be_empty
      expect(json['stamps'].size).to eq(10)
    end

    it 'returns status code 200' do
      subject
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET v1/stamps/:id' do
    subject(:request) { get "/v1/stamps/#{stamp.id}" }

    context 'when the record exists' do
      it 'returns the stamp' do
        subject
        expect(json).not_to be_empty
        expect(json['id']).to eq(stamp.id)
      end

      it 'returns status code 200' do
        subject
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      before { stamp.delete }

      it 'returns status code 404' do
        subject
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        subject
        expect(response.body).to match(/Couldn't find Stamp/)
      end
    end
  end
end