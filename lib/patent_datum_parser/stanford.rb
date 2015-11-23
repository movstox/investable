class PatentDatumParser::Stanford < PatentDatumParser::Base
  def stage_of_research
    start_searching = false
    stop_searching = false
    page.search('//*[@id="wrap"]').first.children.map { |child_node|
      data = child_node.text if start_searching && !stop_searching
      start_searching = true if (child_node.name == 'b') && (child_node.text.downcase.gsub(/\s$/,'').scan(/stage of research/).any?) 
      stop_searching = true if (child_node.name == 'b') && (child_node.text.downcase.gsub(/\s$/,'').scan(/stage of research/).empty?) 
      data.gsub(/\r\n/, '') if data.present? && !data.empty? && !stop_searching
    }.compact
  end

  def inventors
    inventors_section = page.search('//h3[contains(., "Innovators")]')
    if inventors_section.any?
      inventors_section.first.next.next.next.children.map {|inventor_text| inventor_text.text.scan(/[\w,-]+\s\w+/).first}
    else
      []
    end
  end

  def invention_novelty
    'N/A'
  end

  def licensing_contact_num
    page.search('//h3[contains(., "Licensing Contact")]').first.next.next.next.next.text
  end

  def licensing_contact_name
    page.search('//h3[contains(., "Licensing Contact")]').first.next.next.text.split(',').first
  end

  def licensing_contact_email
    'N/A'
  end

  def value_proposition
    section = page.search('//h3[contains(., "Advantages")]')
    if section.any?
      section.first.next.next.next.children.map{|i| i.text}
    else
      []
    end
  end

  def applications
    section = page.search('//h3[contains(., "Applications")]')
    if section.any?
      section.first.next.next.next.children.map{|i| i.text}
    else
      []
    end
  end

  def abstract
    stop_searching = false
    page.search('//*[@id="wrap"]').first.children.map { |child_node|
      stop_searching = true if (child_node.name == 'b')
      child_node.text unless stop_searching
    }.compact.join(' ')
  end

  def patent_status
    patent_status_section = page.search('//h3[contains(., "Patent Status")]')
    if patent_status_section.any?
      patent_status_section.first.next.next.next.children.map{|x| x.text}.first.split(': ').first
    else
      'N/A'
    end
  end

  def patent_release_date
    patent_release_date_section = page.search('//h3[contains(., "Date Released")]')
    if patent_release_date_section.any?
      patent_release_date_section.first.next.text
    else
      'N/A'
    end
  end
  
  def patent_status_ref
    patent_status_section = page.search('//h3[contains(., "Patent Status")]')
    if patent_status_section.any?
      patent_status_section.first.next.next.next.children.map{|x| x.text}.first.split(': ').last
    else
      'N/A'
    end
  end
  
  def keywords
    page.links_with(href: /search=keyword/).map{|l| l.text}
  end

  def ref
    page.search('//h2[contains(., "Reference")]').first.next.next.text
  end

  def title
    page.search('//*[@id="Standard"]/h1').text
  end
  
  def publications
    publications_section = page.search('//h3[contains(., "Publications")]')
    if publications_section.any?
      publications_section.first.next.next.next.children.map do |x|
        {
          title: x.text,
          link: ''
        }
      end
    else
      'N/A'
    end
  end
end
