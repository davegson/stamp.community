RSpec.describe LabelPolicy do
  subject { described_class.new(user, label) }
  let(:label) { FactoryBot.create(:label) }

  context 'for a visitor' do
    let(:user) { nil }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context 'for a user' do
    let(:user) { FactoryBot.create(:user) }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_edit_and_update_actions }
  end
end
