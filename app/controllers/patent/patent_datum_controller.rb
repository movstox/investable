class Patent::PatentDatumController < ApplicationController
  before_action :set_section_order
  
  def berkeley
    @p = remap get_berkley(params[:ref_id])
    @institution = 'Berkeley'
    render 'patent_view'
  end

  def ucsf
    @p = remap get_ucsf(params[:ref_id])
    @institution = 'UCSF'
    render 'patent_view'
  end

  def stanford
    @p = remap get_stanford(params[:ref_id])
    @institution = 'Stanford'
    render 'patent_view'
  end

  protected
  def remap(arr)
    {}.tap do |h|
      arr.each do |el|
        h[el[:id]] = el
      end
    end
  end

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

  def set_section_order
    @section_order = [
      :value_proposition,
      :patent_applications,
      :applications,
      :invention_novelty,
      :inventors,
      :stage_of_research,
      :publications,
      :keywords
    ]
  end
end
