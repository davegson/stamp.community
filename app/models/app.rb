class App < ApplicationRecord
  # needed to load uuid that is generated by postgres
  # https://github.com/rails/rails/issues/21627#issuecomment-142625429
  # https://www.devmynd.com/blog/db-generated-values-and-activerecord/
  after_create :reload

  jsonb_accessor :os, (::ENVProxy.required_array('OPERATING_SYSTEMS')
                                 .each_with_object({}) do |os, h|
                                   h[os] = [:boolean, default: false]
                                 end)

  belongs_to :user
  has_many :stamps, as: :stampable

  # Strip https:// or http://
  before_validation(on: :create) do
    self.link = link.gsub(%r{https?:\/\//, ''}) if attribute_present?('link')
  end

  validates_presence_of %i[description link name user]
  # db will insert a default value
  validates :uuid, presence: true, unless: proc { |obj| obj.new_record? }
  validate :supports_one_or_more_operating_systems
  validates :link, format: {
    with: Domain::NAME_REGEX_WITH_ANCHORS,
    message: 'is not a valid domain name'
  }

  def flag_stamps
    stamps.where(type: 'Stamp::Flag')
  end

  def flag_stamp
    @flag_stamp ||= flag_stamps.accepted.first
  end

  def identifier_stamps
    stamps.where(type: 'Stamp::Identifier')
  end

  def operating_systems
    @operating_systems ||= ENVProxy.required_array('OPERATING_SYSTEMS')
  end

  def supports_one_or_more_operating_systems
    counts = operating_systems.map { |os| send("#{os}?") }
                              .group_by(&:itself)
                              .transform_values(&:count)

    return true if counts[true].present?

    os_hash = operating_systems.each_with_object({}) { |f, h| h[f] = send(f) }
    errors.add(:os, "- at least one operating system must be supported by the app #{os_hash}")
  end
end
