class CreateStageOfResearchIndices < ActiveRecord::Migration
  def change
    create_table :stage_of_research_indices do |t|
      t.string :stage, null: false

      t.timestamps null: false
    end
    add_index :stage_of_research_indices, :stage, unique: true
  end
end
