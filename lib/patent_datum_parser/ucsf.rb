class PatentDatumParser::UCSF < PatentDatumParser::Base
  def stage_of_research
    text_section 'Stage of Development'
  end

  def inventors
    inventors_section = page.search('//h3[contains(., "Inventors")]')
    if inventors_section.any?
      inventors_section.first.next.children.map {|x| x.text}
    else
      []
    end
  end

  def licensing_contact_num
    section = page.search('//*[@id="hiddenPhoneNumber"]')
    if section.any?
      section.first['value']
    else
      'N/A'
    end
  end

  def licensing_contact_name
    section = page.search('//*[@id="contact-person"]')
    if section.present?
      section.text
    else
      'N/A'
    end
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
    text_section 'Invention Novelty'
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
    text_section 'Technology Description'
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
  protected

  def text_section(section_title)
    stop_searching = false
    child_node = page.search("//h3[contains(., \"%s\")]" % section_title).first
    return [] unless child_node.present?
    [].tap { |lines|
      until stop_searching do
        child_node = child_node.next 
        stop_searching = true if (child_node.name == 'h3') 
        text = child_node.text
        lines << text unless stop_searching || text.empty? 
      end
    }.compact
  end
end
