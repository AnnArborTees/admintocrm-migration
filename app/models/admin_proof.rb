class AdminProof < ActiveRecord::Base
  belongs_to :order, foreign_key: :order_id

  validates :order_id, presence: true

  def self.create_from_admin_job_and_proof(aj, proof)
    admin_proof = self.find_or_initialize_by(
      order_id: aj.custom_order_id,
      file_url: proof.file_path
    )
    admin_proof.thumbnail_url = proof.file_path
    admin_proof.save
    return admin_proof 
  end
end
