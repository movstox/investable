class AddInstitutionIdToPatentRaw < ActiveRecord::Migration
  def change
    add_reference :patent_raws, :institution, index: true, foreign_key: true
    PatentRaw.all.each do |patent_raw|
      patent_raw.institution_id = patent_raw.patent_entry.institution_id
      patent_raw.save! 
    end
  end
end
