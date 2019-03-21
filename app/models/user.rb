class User < ApplicationRecord
  include PublicActivity::Common
  include PublicActivity::Owner
  include Roles
  include Relations

  validates_presence_of %i[role username]

  devise :confirmable, :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable

  def voting_power
    reputation <= 0 ? 0 : reputation.log10_power
  end

  def can_vote?(votable)
    votes.today.count < daily_voting_limit && !votes.where(votable: votable).exists?
  end

  def daily_voting_limit
    ENVProxy.required_integer('USER_DAILY_VOTING_LIMIT')
  end

  def top_labels(limit: 5)
    Label.joins(:stamps)
         .where(stamps: { user_id: id })
         .group('labels.id, labels.name')
         .select('labels.name, labels.id, COUNT(labels.name)')
         .order('COUNT(labels.name) DESC, labels.name ASC')
         .limit(limit)
  end

  def voted?(votable)
    votable.votes.where(user_id: id).exists?
  end

  def curent_flow
    boosts.where("created_at >= ?", Time.now - 1.month).sum(:reputation).to_i
  end
end

# Schema Info:
#
# reputation: is a counter_cache from user#boosts reputation sum => Boost
#   - this value is corrected once a day to keep it accutare => RecalcCounterCachesWorker
