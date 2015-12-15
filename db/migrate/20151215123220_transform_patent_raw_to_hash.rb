class TransformPatentRawToHash < ActiveRecord::Migration
  def change
    PatentRaw.all.each do |patent_raw|
      patent_raw.update_attributes(raw_data: ::PatentUtils.remap(patent_raw.raw_data))
    end
  end
end
