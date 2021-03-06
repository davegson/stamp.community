# custom class since it is not possible to add constant via .class_eval
class Activity
  KEYS = %w[
    app.create
    comment.create
    domain.create
    stamp.accept
    stamp.archive
    stamp.create
    stamp.deny
    stamp.dispute
    user.signup
    vote.create
  ].freeze

  def persisted?
    false
  end
end
