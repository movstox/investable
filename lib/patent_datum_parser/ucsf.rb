class PatentDatumParser::UCSF < PatentDatumParser::Base
 def licensing_contact_num
    page.search('//*[@id="hiddenPhoneNumber"]').first['value']
  end

  def licensing_contact_name
    page.search('//*[@id="contact-person"]').text
  end

  def value_proposition
    data = page.search('//h3[contains(., "Value Proposition")][1]/following-sibling::node()[count(.|//h3[contains(., "Technology Description")][1]/preceding-sibling::node()) = count(//h3[contains(., "Technology Description")][1]/preceding-sibling::node())]').map {|x| x.text unless x.text.gsub(/\s/,'').empty?}.compact
    if data.empty?
      # try another strategy
      advantages_section = page.search('//h3[contains(., "Advantages")]')
      if advantages_section.any?
        data = advantages_section.first.next.next.children.map {|x| x.text}
      end
    end
    data
  end

  def applications
    data = page.search('//h3[contains(., "Invention Novelty")][1]/following-sibling::node()[count(.|//h3[contains(., "Technology Description")][1]/preceding-sibling::node()) = count(//h3[contains(., "Technology Description")][1]/preceding-sibling::node())]').map {|x| x.text unless x.text.gsub(/\s/,'').empty?}.compact

    if data.empty?
      # try another strategy
      applications_section = page.search('//h3[contains(., "Applications")]')
      if applications_section.any?
        data = applications_section.first.next.next.children.map {|x| x.text}
      end
    end

    if data.empty?
      # try another strategy
      applications_section = page.search('//h3[contains(., "Application")]')
      if applications_section.any?
        data = applications_section.first.next.next.children.map {|x| x.text}
      end
    end

    if data.empty?
      # try another strategy
      applications_section = page.search('//h3[contains(., "Applications")]')
      if applications_section.any?
        data = applications_section.first.next.next.children.map {|x| x.text}
      end
    end

    if data.empty?
      # try another strategy
      data = page.search('//h3[contains(., "Invention Novelty")][1]/following-sibling::node()[count(.|//h3[contains(., "Value Proposition")][1]/preceding-sibling::node()) = count(//h3[contains(., "Value Proposition")][1]/preceding-sibling::node())]').map {|x| x.text unless x.text.gsub(/\s/,'').empty?}.compact
    end
    data
  end

  def abstract
    data = page.search('//h3[contains(., "Technology Description")][1]/following-sibling::node()[count(.|//h3[contains(., "Applications")][1]/preceding-sibling::node()) = count(//h3[contains(., "Applications")][1]/preceding-sibling::node())]').map {|x| x.text unless x.text.gsub(/\s/,'').empty?}.compact
    if data.empty?
      # try another strategy
      if page.search('//h3[contains(., "Technology Description")]').any? && page.search('//h3[contains(., "Application")]').any?
        data = page.search('//h3[contains(., "Technology Description")][1]/following-sibling::node()[count(.|//h3[contains(., "Application")][1]/preceding-sibling::node()) = count(//h3[contains(., "Application")][1]/preceding-sibling::node())]').map { |x| 
          x.text unless x.text.gsub(/\s/,'').empty?
        }.compact
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
