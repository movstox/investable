class PatentDatumParser::Base
  attr_reader :opts

  LABELS = {
    title: 'Title',
    ref: 'Internal Reference Number',
    keywords: 'Keywords',
    patent_status: 'Patent status',
    patent_status_ref: 'Patent status ref #',
    abstract: 'Abstract',
    applications: 'Applications',
    invention_novelty: 'Invention Novelty',
    value_proposition: 'Value proposition',   
    licensing_contact_name: 'Licensing Contact Name', 
    licensing_contact_num: 'Licensing Contact Phone',
    licensing_contact_email: 'Licensing Contact Email',
    inventors: 'Inventors',
    stage_of_research: 'Stage of Research'
  }

  def initialize(opts)
    @opts = opts
  end

  def to_hash
    [
      :title,
      :ref,
      :keywords,
      :patent_status,
      :patent_status_ref,
      :abstract,
      :applications,
      :invention_novelty,
      :value_proposition,
      :licensing_contact_name,
      :licensing_contact_num,
      :licensing_contact_email,
      :inventors,
      :stage_of_research
    ].map do |data_key|
      {
        id: data_key,
        label: LABELS[data_key],
        value: self.send(data_key)
      }
    end
  end

  protected
  def page
    opts[:page]
  end

  def text_between(section1_title, section2_title)
    path = "//h3[contains(., \"%{section1}\")][1]/following-sibling::node()[count(.|//h3[contains(., \"%{section2}\")][1]/preceding-sibling::node()) = count(//h3[contains(., \"%{section2}\")][1]/preceding-sibling::node())]" % {
      section1: section1_title,
      section2: section2_title
    }
    data = page.search(path).map {|x| 
      s = x.text.gsub(/&nbsp;/,'').gsub(/^\r\n/,'').gsub(/.\r\n/,'. ').gsub(/\.{2,}/,'')
      s unless s.gsub(/\s/, '').empty?
    }.compact
  end
end
