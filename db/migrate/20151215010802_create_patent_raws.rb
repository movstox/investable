class CreatePatentRaws < ActiveRecord::Migration
  def change
    create_table :patent_raws do |t|
      t.json :raw_data
      t.references :patent_entry, index: true, foreign_key: true
      t.string :state, null: false

      t.timestamps null: false
    end
  end
end
