class PatentDatumParser::Stanford < PatentDatumParser::Base
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

  def patent_status_ref
    page.search('//*[@id="Standard"]/ul[6]/li/a').text.split(': ').last
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
  
  def patent_status
    page.search('//*[@id="Standard"]/ul[6]/li/a').text.split(': ').first
  end
end
