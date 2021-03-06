class Votable::AcceptWorker
  include Sidekiq::Worker

  def perform(votable_type, votable_id)
    votable = votable_type.constantize.find(votable_id)
    raise Votable::NotInProgressError unless votable.in_progress?

    votable.accept!
  end
end
