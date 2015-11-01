class Scrape::PatentDatumController < ApplicationController
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
  end
end
