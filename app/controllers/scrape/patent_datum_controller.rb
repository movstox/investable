class Scrape::PatentDatumController < ApplicationController
  before_action :init_scraper

  def berkeley
    @patent_datum = @scraper.scrape_berkley params[:ref_id]
    render 'patent_datum'
  end

  def ucsf
    @patent_datum = @scraper.scrape_ucsf params[:ref_id]
    render 'patent_datum'
  end

  def stanford
    @patent_datum = @scraper.scrape_stanford params[:ref_id]
    render 'patent_datum'
  end

  def view_berkeley
    @patent_datum = @scraper.scrape_berkley params[:ref_id]
    render 'patent_view'
  end

  def view_ucsf
    @patent_datum = @scraper.scrape_ucsf params[:ref_id]
    render 'patent_view'
  end

  def view_stanford
    @patent_datum = @scraper.scrape_stanford params[:ref_id]
    render 'patent_view'
  end

  protected
  def init_scraper
    @scraper = ::PatentDatumScraper::Base.new
  end
end
