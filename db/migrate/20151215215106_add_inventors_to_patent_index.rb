class AddInventorsToPatentIndex < ActiveRecord::Migration
  def change
    add_column :patent_indices, :inventors, :string
  end
end
