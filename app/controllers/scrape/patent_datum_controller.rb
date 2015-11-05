class Scrape::PatentDatumController < ApplicationController
  def ucsf
    url = 'https://techtransfer.universityofcalifornia.edu/NCD/%s.html' % params[:ref_id]
    @patent_datum = scrape ::PatentDatumParser::UCSF, url
    render 'patent_datum'
  end

  def stanford
    url = 'http://techfinder.stanford.edu/technology_detail.php'
    vars = { ID: params[:ref_id] } # patent id
    @patent_datum = scrape ::PatentDatumParser::Stanford, url, vars
    render 'patent_datum'
  end

  protected
  def scrape(parser_class, url, params = {})
    page = Mechanize.new.get(url, params)
    parser_class.new(page: page).to_hash
  end
end
