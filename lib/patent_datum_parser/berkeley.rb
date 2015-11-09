class PatentDatumParser::Berkeley < PatentDatumParser::UCSF
  def stage_of_research
    'N/A'
  end

  def abstract
    text_between('Brief Description', 'Suggested uses')
  end

  def applications
    text_between('Suggested uses', 'Advantages')
  end
end
