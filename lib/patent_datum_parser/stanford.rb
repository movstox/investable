class PatentDatumParser::Stanford < PatentDatumParser::Base

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
    page.search('//h3[contains(., "Licensing Contact")]').first.next.next.text
  end

  def value_proposition
    page.search('//*[@id="Standard"]/ul[2]').children.map{|l| l.text}
  end

  def applications
   page.search('//*[@id="Standard"]/ul[1]').children.map{|l| l.text}
  end

  def abstract
    page.search('//*[@id="wrap"]').text
  end

  def patent_status
    patent_status_section = page.search('//h3[contains(., "Patent Status")]')
    if patent_status_section.any?
      patent_status_section.first.next.next.next.children.map{|x| x.text}.first.split(': ').first
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
    page.search('//*[@id="Standard"]/h3[1]').text
  end

  def title
    page.search('//*[@id="Standard"]/h1').text
  end
end
