class CreateAdminProofs < ActiveRecord::Migration
  def change
    create_table :admin_proofs do |t|
      t.integer :order_id
      t.string :file_url
      t.string :thumbnail_url

      t.timestamps null: false
    end
  end
end
