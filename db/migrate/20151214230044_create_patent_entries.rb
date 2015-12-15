class CreatePatentEntries < ActiveRecord::Migration
  def change
    create_table :patent_entries do |t|
      t.references :institution, index: true, foreign_key: true
      t.integer :ref
      t.string :state, null: false

      t.timestamps null: false
    end
    add_index :patent_entries, [:ref, :institution_id], unique: true
  end
end
