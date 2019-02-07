FactoryBot.define do
  factory :activity, class: PublicActivity::Activity do
    association :owner, factory: :user
  end

  factory :domain_activity, parent: :activity do
    association :trackable, factory: :domain

    key { 'domain.create' }
  end

  factory :app_activity, parent: :activity do
    association :trackable, factory: :app

    key { 'app.create' }
  end

  factory :signup_activity, parent: :activity do
    association :trackable, factory: :user
    key { 'user.signup' }
  end

  factory :transition_activity, parent: :activity do
    association :trackable, factory: :flag_stamp
    owner_type { 'System' }
    owner_id { -1 }
    key { 'stamp.accept' }
  end

  factory :vote_activity, parent: :activity do
    trackable { build(:vote, user: owner) }
    key { 'vote.create' }
  end
end
