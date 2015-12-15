class Patent::PatentDatumController < ApplicationController
  before_action :set_section_order
  before_action :init_scraper

  def berkeley
    @institution = 'Berkeley'
    @p = get_or_scrape(@institution.downcase, params[:ref_id])
    render 'patent_view'
  end

  def get_or_scrape(institution_name, ref_id)
    institution = Institution.find_by(name: institution_name)
    patent_index = PatentIndex
      .find_by(institution: institution, ref: ref_id.to_i)
    raw_data = if patent_index.present?
        patent_index.patent_raw.raw_data
      else
        remap(@scraper.send(('scrape_%s'%institution_name.downcase).to_sym, ref_id))
      end
  end

  def ucsf
    @institution = 'UCSF'
    @p = get_or_scrape(@institution.downcase, params[:ref_id])
    render 'patent_view'
  end

  def stanford
    @institution = 'Stanford'
    @p = get_or_scrape(@institution.downcase, params[:ref_id])
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
