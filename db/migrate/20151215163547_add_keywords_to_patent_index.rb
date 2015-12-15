class AddKeywordsToPatentIndex < ActiveRecord::Migration
  def change
    add_column :patent_indices, :keywords, :string
    add_index :patent_indices, :keywords
  end
end
