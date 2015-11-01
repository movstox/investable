class CreatePatentData < ActiveRecord::Migration
  def change
    create_table :patent_data do |t|
      t.json :datum

      t.timestamps null: false
    end
  end
end
