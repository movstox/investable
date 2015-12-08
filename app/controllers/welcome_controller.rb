class WelcomeController < ApplicationController
  def index2
  end

  def index
  end
  
  def search
    @bulk_data = [
      {
        id: 36232,
        institution: 'stanford'
      },
      {
        id: 31507,
        institution: 'stanford'
      },
      {
        id: 29491,
        institution: 'stanford'
      },
      {
        id: 28385,
        institution: 'stanford'
      },
      {
        id: 30055,
        institution: 'stanford'
      },
      {
        id: 25052,
        institution: 'ucsf'
      },
      {
        id: 25018,
        institution: 'ucsf'
      },
      {
        id: 24912,
        institution: 'ucsf'
      },
      {
        id: 24863,
        institution: 'ucsf'
      }
    ]
    
    @results = @bulk_data.map do |patent_to_find|
      patent_to_find.merge(data: get_data(patent_to_find))
    end
  end

  protected
  def remap(arr)
    {}.tap do |h|
      arr.each do |el|
        h[el[:id]] = el
      end
    end
  end

  def get_data(patent_to_find)
    remap self.send('get_%s'%patent_to_find[:institution], patent_to_find[:id])
  end

  def get_berkley(id)
    url = 'https://techtransfer.universityofcalifornia.edu/NCD/%s.html' % id
    scrape ::PatentDatumParser::Berkeley, url
  end

  def get_ucsf(id)
    url = 'https://techtransfer.universityofcalifornia.edu/NCD/%s.html' % id
    scrape ::PatentDatumParser::UCSF, url
  end

  def get_stanford(id)
    url = 'http://techfinder.stanford.edu/technology_detail.php'
    vars = { ID: id } # patent id
    scrape ::PatentDatumParser::Stanford, url, vars
  end

  def scrape(parser_class, url, params = {})
    page = Mechanize.new.get(url, params)
    parser_class.new(page: page).to_hash
  end
end
