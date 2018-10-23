class App < ApplicationRecord
  # needed to load uuid that is generated by postgres
  # https://github.com/rails/rails/issues/21627#issuecomment-142625429
  # https://www.devmynd.com/blog/db-generated-values-and-activerecord/
  after_create :reload

  belongs_to :user

  validates_presence_of %i[description link name user uuid]
end