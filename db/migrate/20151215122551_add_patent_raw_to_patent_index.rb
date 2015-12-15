class AddPatentRawToPatentIndex < ActiveRecord::Migration
  def change
    add_reference :patent_indices, :patent_raw, index: true, foreign_key: true
  end
end
