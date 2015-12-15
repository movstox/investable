class MakePatentIdNotNull < ActiveRecord::Migration
  def change
    change_column :patent_indices, :patent_id, :string, null: false
  end
end
