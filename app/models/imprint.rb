class Imprint < ActiveRecord::Base
  belongs_to :job, foreign_key: :job_id
  belongs_to :print_location
  has_one :imprint_method, through: :print_location

  validates :job, presence: true

  def self.create_from_job_and_method(job, description)
    imprint = Imprint::find_or_initialize_by(
      job_id: job.id,
      description: description,
      print_location_id: PRINT_LOCATION_MAP[description]
    )

    if imprint.new_record?
      imprint.save
    end

    return imprint
  end




  # 4 Screen Print  Full Chest
  # 16  Screen Print  Full Back
  # 5 Screen Print  Left Chest
  #



end
