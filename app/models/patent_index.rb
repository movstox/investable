class PatentIndex < ActiveRecord::Base
  belongs_to :patent_raw
  belongs_to :stage_of_research_index
  belongs_to :patent_status_index
  belongs_to :institution

  validates :patent_raw_id, presence: true
  validates :stage_of_research_index_id, presence: true
  validates :patent_status_index_id, presence: true
  validates :institution_id, presence: true

  acts_as_taggable_on :keywords

  def abstract
    patent_raw.raw_data['abstract']['value']
  end

  def institution_name
    institution.name
  end
  
  def status_label
    patent_status_index.status
  end

  def stage_of_research_label
    stage_of_research_index.stage
  end
end
