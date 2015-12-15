class FillPatentId < ActiveRecord::Migration
  def up
    PatentIndex.all.each do |patent_index|
      patent_index.patent_id = patent_index.patent_raw.raw_data['ref']['value'] 
      patent_index.save!
    end
  end
end
