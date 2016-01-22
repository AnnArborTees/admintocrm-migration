class Imprint < ActiveRecord::Base
  belongs_to :job, foreign_key: :job_id

  validates :job, presence: true

  def self.create_from_job_and_method(job, imprint_method)
    imprint = Imprint::find_or_create_by(
      job_id: job.id,
      description: imprint_method
    )
    imprint.save
    return imprint
  end
end
