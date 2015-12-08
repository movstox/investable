class Scrape::PatentDatumController < ApplicationController
  def berkeley
    @patent_datum = get_berkley params[:ref_id]
    render 'patent_datum'
  end

  def ucsf
    @patent_datum = get_ucsf params[:ref_id]
    render 'patent_datum'
  end

  def stanford
    @patent_datum = get_stanford params[:ref_id]
    render 'patent_datum'
  end

  def view_berkeley
    @patent_datum = get_berkley params[:ref_id]
    render 'patent_view'
  end

  def view_ucsf
    @patent_datum = get_ucsf params[:ref_id]
    render 'patent_view'
  end

  def view_stanford
    @patent_datum = get_stanford params[:ref_id]
    render 'patent_view'
  end

  protected
  def get_berkley(id)
    url = 'https://techtransfer.universityofcalifornia.edu/NCD/%s.html' % params[:ref_id]
    scrape ::PatentDatumParser::Berkeley, url
  end

  def get_ucsf(id)
    url = 'https://techtransfer.universityofcalifornia.edu/NCD/%s.html' % params[:ref_id]
    scrape ::PatentDatumParser::UCSF, url
  end

  def get_stanford(id)
    url = 'http://techfinder.stanford.edu/technology_detail.php'
    vars = { ID: params[:ref_id] } # patent id
    scrape ::PatentDatumParser::Stanford, url, vars
  end

  def scrape(parser_class, url, params = {})
    page = Mechanize.new.get(url, params)
    parser_class.new(page: page).to_hash
  end
end
