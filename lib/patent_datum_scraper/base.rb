class PatentDatumScraper::Base
  def scrape_berkley(id)
    url = 'https://techtransfer.universityofcalifornia.edu/NCD/%s.html' % id
    scrape ::PatentDatumParser::Berkeley, url
  end

  def scrape_ucsf(id)
    url = 'https://techtransfer.universityofcalifornia.edu/NCD/%s.html' % id
    scrape ::PatentDatumParser::UCSF, url
  end

  def scrape_stanford(id)
    url = 'http://techfinder.stanford.edu/technology_detail.php'
    vars = { ID: id } # patent id
    scrape ::PatentDatumParser::Stanford, url, vars
  end

  protected
  def scrape(parser_class, url, params = {})
    page = Mechanize.new.get(url, params)
    parser_class.new(page: page).to_hash
  end
end
