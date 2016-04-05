class AdminProof < ActiveRecord::Base
  belongs_to :order, foreign_key: :order_id

  validates :order_id, presence: true

  def self.create_from_order_id_and_proof(order_id, proof)
    admin_proof = self.find_or_initialize_by(
      order_id: order_id,
      file_url: proof.file_path
    )
    admin_proof.thumbnail_url = proof.file_path

    if admin_proof.new_record?
      admin_proof.save
    end

    return admin_proof
  end
end
