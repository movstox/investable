class PatentDatumParser::UCSF < PatentDatumParser::Base
 def licensing_contact_num
    page.search('//*[@id="hiddenPhoneNumber"]').first['value']
  end

  def licensing_contact_name
    page.search('//*[@id="contact-person"]').text
  end

  def value_proposition
    page.search('//h3[contains(., "Value Proposition")][1]/following-sibling::node()[count(.|//h3[contains(., "Technology Description")][1]/preceding-sibling::node()) = count(//h3[contains(., "Technology Description")][1]/preceding-sibling::node())]').map {|x| x.text unless x.text.gsub(/\s/,'').empty?}.compact
  end

  def applications
    page.search('//h3[contains(., "Invention Novelty")][1]/following-sibling::node()[count(.|//h3[contains(., "Technology Description")][1]/preceding-sibling::node()) = count(//h3[contains(., "Technology Description")][1]/preceding-sibling::node())]').map {|x| x.text unless x.text.gsub(/\s/,'').empty?}.compact
  end

  def abstract
    page.search('//h3[contains(., "Technology Description")][1]/following-sibling::node()[count(.|//h3[contains(., "Applications")][1]/preceding-sibling::node()) = count(//h3[contains(., "Applications")][1]/preceding-sibling::node())]').map {|x| x.text unless x.text.gsub(/\s/,'').empty?}.compact
  end

  def patent_status_ref
    patent_status_ref_section = page.search('//h3[contains(., "Patent Status")]')
    if patent_status_ref_section.any?
      patent_status_ref_section.first.try(:next).next.children.search('tr')[1].children[5].text.gsub(/,/,'')
    else
      'N/A'
    end
  end
  
  def keywords
    page.search('//*[@id="subBlockThree"]/div/section/div[2]/section/div[5]').children.first.next.text.split(', ')
  end

  def ref
    page.search('//*[@id="subBlockThree"]/div/section/div[1]/div[1]').text
  end

  def title
    page.search('//*[@id="subBlockThree"]/div/section/div[1]/h1').text
  end
  
  def patent_status
    patent_status_section = page.search('//h3[contains(., "Patent Status")]')
    if patent_status_section.any?
      patent_status_section_content = patent_status_section.first.next.next
      if patent_status_section_content.name == 'p'
        patent_status_section_content.text
      else
        patent_status_section_content.children.search('tr')[1].children[3].text
      end
    else
      'N/A'
    end
  end
end
