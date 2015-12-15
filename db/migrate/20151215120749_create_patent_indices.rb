class CreatePatentIndices < ActiveRecord::Migration
  def change
    create_table :patent_indices do |t|
      t.references :stage_of_research_index, index: true, foreign_key: true
      t.references :patent_status_index, index: true, foreign_key: true
      t.references :institution, index: true, foreign_key: true
      t.string :title
      t.integer :ref

      t.timestamps null: false
    end
    add_index :patent_indices, [:ref, :institution_id]
  end
end
