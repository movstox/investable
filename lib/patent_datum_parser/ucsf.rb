class PatentDatumParser::UCSF < PatentDatumParser::Base
  def inventors
    inventors_section = page.search('//h3[contains(., "Inventors")]')
    if inventors_section.any?
      inventors_section.first.next.children.map {|x| x.text}
    else
      []
    end
  end

  def licensing_contact_num
    page.search('//*[@id="hiddenPhoneNumber"]').first['value']
  end

  def licensing_contact_name
    page.search('//*[@id="contact-person"]').text
  end

  def value_proposition
    data = text_between 'Value Proposition', 'Technology Description'
    if data.empty?
      # try another strategy
      advantages_section = page.search('//h3[contains(., "Advantages")]')
      if advantages_section.any?
        data = advantages_section.first.next.next.children.map {|x| x.text}
      end
    end
    data
  end

  def invention_novelty
    data = text_between 'Invention Novelty', 'Value Proposition'
    if data.empty?
      # try another strategy
      data = text_between 'Invention Novelty', 'Technology Description'
    end
    data
  end

  def applications
    data = text_between 'Application', 'Looking for Partners'

    if data.empty?
      # try another strategy
      applications_section = page.search('//h3[contains(., "Applications")]')
      if applications_section.any?
        data = applications_section.first.next.next.children.map {|x| x.text}
      end
    end
    data
  end

  def abstract
    data = text_between 'Technology Description', 'Applications'
    if data.empty?
      # try another strategy
      if page.search('//h3[contains(., "Technology Description")]').any? && page.search('//h3[contains(., "Application")]').any?
        data = text_between 'Technology Description', 'Application'
      end
    end
    data
  end

  def patent_status_ref
    patent_status_ref_section = page.search('//h3[contains(., "Patent Status")]')
    if patent_status_ref_section.any?
      patent_status_ref_table = patent_status_ref_section.first.try(:next).next
      if patent_status_ref_table.name == 'table'
        patent_status_ref_table.children.search('tr')[1].children[5].text.gsub(/,/,'')
      else
        'N/A'
      end
    else
      'N/A'
    end
  end
  
  def keywords
    section = page.search('//*[@id="subBlockThree"]/div/section/div[2]/section/div[5]')
    if section.children.any?
      section.children.first.next.text.split(', ')
    else
      []
    end
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
