RSpec.describe V1::LabelsAPI, type: :request do
  let!(:labels) { FactoryBot.create_list(:label, 5) }
  let(:label) { labels.first }

  describe 'GET v1/labels' do
    subject(:request) { get '/v1/labels' }

    it 'returns labels' do
      subject
      expect(json['labels']).not_to be_empty
      expect(json['labels'].size).to eq(5)
    end
  end

  describe 'GET v1/labels/:id' do
    subject(:request) { get "/v1/labels/#{label.id}" }

    context 'when the label exists' do
      it 'returns the label' do
        subject
        expect(json['id']).to eq(label.id)
      end

      it 'returns status code 200' do
        subject
        expect(response).to have_http_status(200)
      end
    end

    context 'when the label does not exist' do
      before { label.delete }

      it 'returns status code 404' do
        subject
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        subject
        expect(response.body).to match(/Couldn't find Label/)
      end
    end
  end

  describe 'GET labels/:id/stamps' do
    subject(:request) { get "/v1/labels/#{label.id}/stamps" }

    context 'when the label exists' do
      it 'returns the label' do
        subject
        expect(json['id']).to eq(label.id)
      end

      it 'returns status code 200' do
        subject
        expect(response).to have_http_status(200)
      end

      context 'label has stamps' do
        let(:label) { FactoryBot.create(:label, :with_stamps) }

        it 'includes the stamps of the label' do
          subject
          expect(json['stamps'].size).to be > 0
        end
      end

      context 'label does not have any stamps' do
        it 'includes an empty array for :stamps' do
          subject
          expect(json['stamps'].size).to eq(0)
          expect(json['stamps']).to eq([])
        end
      end
    end

    context 'when the label does not exist' do
      before { label.delete }

      it 'returns status code 404' do
        subject
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        subject
        expect(response.body).to match(/Couldn't find Label/)
      end
    end
  end
end
