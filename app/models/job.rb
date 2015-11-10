class Job < ActiveRecord::Base
  belongs_to :order, foreign_key: :jobbable_id
  has_many :line_items, foreign_key: :line_itemable_id
  has_many :imprints, foreign_key: :job_id

  validates :order, presence: true
  validates :name, presence: true
  validates :description, presence: true

  def self.new_job_from_admin_job(admin_job)
    if admin_job.title.blank?
      return nil
    end

    self.find_or_initialize_by( 
      name: admin_job.title,
      description: admin_job.description,
    )
  end
end
