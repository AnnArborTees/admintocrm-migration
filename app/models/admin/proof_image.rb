class Admin::ProofImage < ActiveRecord::Base
  belongs_to :job, class_name: "Admin::Job", foreign_key: :job_id

  validates :filename, presence: true
  validates :job_id, presence: true

  def file_path
    return "http://s3.amazonaws.com/admin.annarbortshirtcompany.com/proof_images/#{self.id}/#{self.filename}"
  end

end
