class Patent::PatentDatumController < ApplicationController
  before_action :set_section_order
  before_action :init_scraper

  def berkeley
    @p = remap @scraper.scrape_berkley(params[:ref_id])
    @institution = 'Berkeley'
    render 'patent_view'
  end

  def ucsf
    @p = remap @scraper.scrape_ucsf(params[:ref_id])
    @institution = 'UCSF'
    render 'patent_view'
  end

  def stanford
    @p = remap @scraper.scrape_stanford(params[:ref_id])
    @institution = 'Stanford'
    render 'patent_view'
  end

  protected
  def init_scraper
    @scraper = ::PatentDatumScraper::Base.new
  end

  def remap(arr)
    {}.tap do |h|
      arr.each do |el|
        h[el[:id]] = el
      end
    end
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
