class AddPatentIdToPatentIndex < ActiveRecord::Migration
  def change
    add_column :patent_indices, :patent_id, :string
    add_index :patent_indices, :patent_id, unique: true
  end
end
