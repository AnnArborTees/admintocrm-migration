class Imprint < ActiveRecord::Base
  belongs_to :job, foreign_key: :job_id

  validates :job, presence: true
end
