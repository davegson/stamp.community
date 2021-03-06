RSpec.describe Domain, type: :model do
  it_behaves_like 'PublicActivity::Recipient', factory: :domain

  it 'has a valid factory' do
    expect(FactoryBot.create(:domain)).to be_valid
  end

  describe 'database' do
    it { is_expected.to have_db_index(:name).unique(true) }
    it { is_expected.to have_db_index(:parent_id) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:parent).class_name('Domain').optional }
    it { is_expected.to have_many(:children).class_name('Domain').with_foreign_key(:parent_id) }
    it { is_expected.to have_many(:stamps) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }

    describe 'domain name validation' do
      it { is_expected.to allow_value('i.oh1.me').for(:name) }
      it { is_expected.to allow_value('assets.fb.com').for(:name) }
      it { is_expected.to allow_value('uni.ac.uk').for(:name) }
      it { is_expected.to allow_value('we.do.many.subs.ac.uk').for(:name) }
      it { is_expected.to allow_value('www.uni.ac.uk').for(:name) }
      it { is_expected.to allow_value('x.com').for(:name) }
      it { is_expected.to allow_value('www.xn--cybr-noa.space').for(:name) }

      it { is_expected.not_to allow_value('https://x.com').for(:name) }
      it { is_expected.not_to allow_value('i.ehthe.oh1.me.').for(:name) }
      it { is_expected.not_to allow_value('e//assets.fb.com').for(:name) }
      it { is_expected.not_to allow_value('uni.').for(:name) }
      it { is_expected.not_to allow_value('no-dot-nono').for(:name) }
      it { is_expected.not_to allow_value('.uni').for(:name) }
      it { is_expected.not_to allow_value('x.com/oahethutoa').for(:name) }
      it { is_expected.not_to allow_value(')*)xn--cybr-noa.space').for(:name) }
    end
  end
end
