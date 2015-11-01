class Scrape::PatentDatumController < ApplicationController
  def ucsf
    url = 'https://techtransfer.universityofcalifornia.edu/NCD/%s.html' % params[:ref_id]
    agent = Mechanize.new
    page = agent.get url
    @patent_datum = [
      {
        id: :title,
        label: 'Title',
        value: page.search('//*[@id="subBlockThree"]/div/section/div[1]/h1').text
      },
      {
        id: :ref,
        label: 'Internal Reference Number',
        value: page.search('//*[@id="subBlockThree"]/div/section/div[1]/div[1]').text
      },
      {
        id: :keywords,
        label: 'Keywords',
        value: page.search('//*[@id="subBlockThree"]/div/section/div[2]/section/div[5]').children.first.next.text.split(', ')
      },
      {
        id: :patent_status,
        label: 'Patent status',
        value: if page.search('//h3[contains(., "Patent Status")]').any?
                 page.search('//h3[contains(., "Patent Status")]').first.next.next.children.search('tr')[1].children[3].text
      else
        'N/A'
      end
      },
      {
        id: :patent_status_ref,
        label: 'Patent status ref #',
        value: if page.search('//h3[contains(., "Patent Status")]').any?
                 page.search('//h3[contains(., "Patent Status")]').first.try(:next).next.children.search('tr')[1].children[5].text.gsub(/,/,'')
      else
        'N/A'
      end
      },
      {
        id: :abstract,
        label: 'Abstract',
        value: page.search('//h3[contains(., "Technology Description")][1]/following-sibling::node()[count(.|//h3[contains(., "Applications")][1]/preceding-sibling::node()) = count(//h3[contains(., "Applications")][1]/preceding-sibling::node())]').map {|x| x.text unless x.text.gsub(/\s/,'').empty?}.compact
      },
      {
        id: :applications,
        label: 'Applications',
        value: page.search('//h3[contains(., "Invention Novelty")][1]/following-sibling::node()[count(.|//h3[contains(., "Technology Description")][1]/preceding-sibling::node()) = count(//h3[contains(., "Technology Description")][1]/preceding-sibling::node())]').map {|x| x.text unless x.text.gsub(/\s/,'').empty?}.compact
      },
      {
        id: :value_proposition,
        label: 'Value Proposition',
        value: page.search('//h3[contains(., "Value Proposition")][1]/following-sibling::node()[count(.|//h3[contains(., "Technology Description")][1]/preceding-sibling::node()) = count(//h3[contains(., "Technology Description")][1]/preceding-sibling::node())]').map {|x| x.text unless x.text.gsub(/\s/,'').empty?}.compact
      },
      {
        id: :licensing_contact_name,
        label: 'Licensing Contact Name',
        value: page.search('//*[@id="contact-person"]').text
      },
      {
        id: :licensing_contact_num,
        label: 'Licensing Contact #',
        value: page.search('//*[@id="hiddenPhoneNumber"]').first['value']
      }
    ]
    render 'patent_datum'
  end

  def stanford
    url = 'http://techfinder.stanford.edu/technology_detail.php'
    vars = { ID: params[:ref_id] } # patent id
    agent = Mechanize.new
    page = agent.get(url, vars)
    @patent_datum = [
      {
        id: :title,
        label: 'Title',
        value: page.search('//*[@id="Standard"]/h1').text
      },
      {
        id: :ref,
        label: 'Internal Reference Number',
        value: page.search('//*[@id="Standard"]/h3[1]').text
      },
      {
        id: :keywords,
        label: 'Keywords',
        value: page.links_with(href: /search=keyword/).map{|l| l.text}
      },
      {
        id: :patent_status,
        label: 'Patent status',
        value: page.search('//*[@id="Standard"]/ul[6]/li/a').text.split(': ').first
      },
      {
        id: :patent_status_ref,
        label: 'Patent status ref #',
        value: page.search('//*[@id="Standard"]/ul[6]/li/a').text.split(': ').last
      },
      {
        id: :abstract,
        label: 'Abstract',
        value: page.search('//*[@id="wrap"]').text
      },
      {
        id: :applications,
        label: 'Applications',
        value: page.search('//*[@id="Standard"]/ul[1]').children.map{|l| l.text}
      },
      {
        id: :value_proposition,
        label: 'Value Proposition',
        value: page.search('//*[@id="Standard"]/ul[2]').children.map{|l| l.text}
      },
      {
        id: :licensing_contact_name,
        label: 'Licensing Contact Name',
        value: page.search('//h3[contains(., "Licensing Contact")]').first.next.next.text
      },
      {
        id: :licensing_contact_num,
        label: 'Licensing Contact #',
        value: page.search('//h3[contains(., "Licensing Contact")]').first.next.next.next.next.text
      }
    ]
    render 'patent_datum'
  end
end
