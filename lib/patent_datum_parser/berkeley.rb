class PatentDatumParser::Berkeley < PatentDatumParser::UCSF
  def abstract
    data = page.search('//h3[contains(., "Brief Description")][1]/following-sibling::node()[count(.|//h3[contains(., "Suggested uses")][1]/preceding-sibling::node()) = count(//h3[contains(., "Suggested uses")][1]/preceding-sibling::node())]').map {|x| x.text unless x.text.gsub(/\s/,'').empty?}.compact
  end
end
