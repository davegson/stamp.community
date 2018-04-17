require 'spec_helper'

RSpec.describe StampPresenter::Entity do
  describe '.represent' do
    subject { StampPresenter::Entity.represent(stamp).as_json }
    let(:stamp) { FactoryBot.create(:stamp) }

    it 'id as Integer' do
      expect(subject[:id]).to be_an(Integer)
      expect(subject[:id]).to eq(stamp.id)
    end

    it 'percentage as Integer' do
      expect(subject[:percentage]).to be_an(Integer)
      expect(subject[:percentage]).to eq(stamp.percentage)
    end

    it 'state as String' do
      expect(subject[:state]).to be_a(String)
      expect(subject[:state]).to eq(stamp.state)
    end
  end
end