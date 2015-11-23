class PatentDatumParser::UCSF < PatentDatumParser::Base
  def stage_of_research
    text_section 'Stage of Development'
  end

  def inventors
    inventors_section = page.search('//h3[starts-with(., "Inventors")]')
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

  def licensing_contact_email
    section = page.search('//*[@id="email"]')
    if section.present?
      section.text
    else
      'N/A'
    end
  end

  def value_proposition
    data = text_section 'Value Proposition'
    if data.empty?
      data = text_section 'Advantages'
    end
    if data.empty?
      data = text_section 'Features'
    end
    data
  end

  def invention_novelty
    data = text_section 'Invention Novelty'
    if data.empty?
      # try another strategy
      data = text_between 'Invention Novelty', 'Technology Description'
    end
    data
  end

  def applications
    data = text_section 'Application'

    if data.empty?
      # try another strategy
      applications_section = page.search('//h3[contains(., "Applications")]')
      if applications_section.any?
        data = applications_section.first.next.next.children.map {|x| x.text}
      end
    end
    data = text_section 'Suggested uses' if data.empty?
    data
  end

  def abstract
    data1 = text_section 'Brief Descri'
    data2 = text_section 'Full Descri'
    data = (data1 + data2).join(' ').gsub(/\s^/,'')
    data = text_section 'Technology Description' if data.empty?
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

  def patent_release_date
    'N/A'
  end

  def patent_applications
    patent_applications_section = page.search('//h3[starts-with(., "Patent Status")]')
    if patent_applications_section.any?
      patent_applications_contents = patent_applications_section.first.next.next
      patent_applications_contents.children.search('//*[contains(@class,"patentRow")]').map do |row|
        columns = row.search('td')
        {
          country: columns[0].text,
          type: columns[1].text,
          number: columns[2].text,
          ref_date: columns[3].text,
          case: columns[4].text
        }
      end
    else
      []
    end
  end

  def publications
    related_materials_section = page.search('//h3[starts-with(., "related materials")]')
    if related_materials_section.any?
      related_materials_contents = related_materials_section.first.next.next
      related_materials_contents.children.map do |li|
        {
          title: li.text , 
          link: uri.unescape(li.search('a').first['href'])
        }
      end
    else
      []
    end
  end
  protected

  def text_section(section_title)
    stop_searching = false
    child_node = page.search("//h3[contains(., \"%s\")]" % section_title).first
    return [] unless child_node.present?
    [].tap { |lines|
      until stop_searching do
        break unless child_node.present?
        child_node = child_node.next
        stop_searching = true if (child_node.present? && child_node.name == 'h3') 
        unless stop_searching or child_node.nil? or child_node.text.empty?
          text = if child_node.name == 'ul'
                   child_node.children.map do |li| 
                     if li.name == 'ul'
                       li.children.map {|c| c.text.gsub(/\s+$/,'').gsub(/^\s+/,'')}
                     else
                       li.text.gsub(/\s+$/,'').gsub(/^\s+/,'')
                     end
                   end
                 else
                   child_node.text.gsub(/\s+$/,'').gsub(/^\s+/,'')
                 end
          lines << text
        end
      end
    }
     .flatten
     .map{|c| c unless c.empty?}
     .compact
  end
end
