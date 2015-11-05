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
    value_proposition: 'Value proposition',   
    licensing_contact_name: 'Licensing Contact Name', 
    licensing_contact_num: 'Licensing Contact Phone' 
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
      :value_proposition
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
end
