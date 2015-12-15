class CreatePatentStatusIndices < ActiveRecord::Migration
  def change
    create_table :patent_status_indices do |t|
      t.string :status, null: true

      t.timestamps null: false
    end
    add_index :patent_status_indices, :status, unique: true
  end
end
