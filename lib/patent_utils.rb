class PatentUtils
  def self.index(opts)
    patent_raw = opts[:patent_raw]
    PatentIndex.find_by(
        institution: patent_raw.institution, 
        ref: patent_raw.patent_entry.ref)
      .try(:destroy)
    index_opts = {
      stage_of_research_index: find_stage_of_research_index(stage_of_research(patent_raw)),
      patent_status_index: find_patent_status_index(patent_status(patent_raw)),
      institution: patent_raw.institution,
      ref: patent_raw.patent_entry.ref,
      title: patent_raw.raw_data['title']['value'],
      patent_id: patent_raw.raw_data['ref']['value'],
      keyword_list: keyword_list(patent_raw)
    }
    patent_raw.create_patent_index(index_opts)
  end

  def self.remap(arr)
    {}.tap do |h|
      arr.each do |el|
        el_id = if el.has_key?('id')
            el['id']
          elsif el.has_key?(:id)
            el[:id]
          else
            raise 'id not found'
          end
        h[el_id] = el
      end
    end
  end

protected
  def self.keyword_list(patent_raw)
    keywords = patent_raw.raw_data['keywords']['value']
    if keywords.kind_of?(Array)
      keywords.join(', ')
    else
      ''
    end
  end

  def self.patent_status(patent_raw)
    patent_raw.raw_data['patent_status']['value']
  end

  def self.stage_of_research(patent_raw)
    val = patent_raw.raw_data['stage_of_research']['value']
    if val.kind_of?(Array)
      val.join('') 
    else
      val
    end
  end

  def self.find_stage_of_research_index(stage_of_research_label)
    StageOfResearchIndex.find_or_create_by(stage: stage_of_research_label)        
  end

  def self.find_patent_status_index(patent_status_label)
    PatentStatusIndex.find_or_create_by(status: patent_status_label)    
  end
end
