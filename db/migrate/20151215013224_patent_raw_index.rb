class PatentRawIndex < ActiveRecord::Migration
  def change
    add_index :patent_raws, :patent_entry_id, unique: true, name: 'one_per_patent'
  end
end
