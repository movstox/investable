namespace :stanford do
  task :sync => :environment do
    institution = Institution.find_by(name: 'Stanford')
    # scan new patent entries into database 
    params = {}
    params['PerformSearch']='Perform Search'
    params['category']=''
    params['form_action']='performsearch'
    params['form_keywords']='bio: healthcare,bio: healthcare: education,bio: healthcare: management,bio: healthcare: diagnostic tool,bio: healthcare: imaging,bio: healthcare: informatics,bio: healthcare: stents,bio: healthcare: ultrasound,bio: healthcare: rehabilitation,bio: healthcare: laser,bio: healthcare: MRI,bio: healthcare: CT scanning,bio: healthcare: non-invasive device,bio: healthcare: X-Ray,bio: healthcare: therapeutic,bio: healthcare: microarrays,bio: healthcare: microscopy,bio: healthcare: biochip,bio: healthcare: CAD/PACS application,bio: healthcare: syringe/needles,bio: healthcare: neonatology/pediatrics'
    params['subtype']='all'
    params['type']='all'
    params['ipp']='all'

    h = 'http://techfinder.stanford.edu/process_keyword_search.php'
    agent = Mechanize.new
    page = agent.post h, params
    all_page = page.links_with(text:'All').first.click
    patent_links = all_page.links_with(text: /^S\d{2}-\d{3}/) 
    patent_links.each do |patent_link|
      ref = patent_link.href.scan(/\d+/).first.to_i
      unless PatentEntry.where(ref: ref, institution: institution).any?
        PatentEntry.create(
          ref: ref,
          institution: institution 
        )
      end
    end
  end

  task :scrape => :environment do
    institution = Institution.find_by(name: 'Stanford')
    scraper = ::PatentDatumScraper::Base.new
    PatentEntry
      .where(state: 'new', institution: institution)
      .each do |patent_entry|
        begin
          p 'Processing patent entry #%s' % patent_entry.id
          sleep 2+rand(10)/10.0
          raw_data = ::PatentUtils.remap scraper.scrape_stanford(patent_entry.ref)
          patent_entry.patent_raw.destroy if patent_entry.patent_raw.present? # destroy old result if present
          patent_raw = patent_entry.create_patent_raw(
            raw_data: raw_data,
            institution: patent_entry.institution
          )
          if patent_raw.valid?
            patent_entry.scrape!
          else
            patent_entry.cancel!
          end  
        rescue Exception => e
          patent_entry.cancel!
          ::ErrorReporter.report(e)
        end
      end
  end

  task :scrape_rebuild => :environment do
    institution = Institution.find_by(name: 'Stanford')
    PatentEntry.where(institution: institution).map(&:retry!)
    Rake::Task["stanford:scrape"].invoke
  end

  task :index => :environment do
    institution = Institution.find_by(name: 'Stanford')
    PatentRaw
      .where(state: 'new', institution: institution)
      .each do |patent_raw|
        begin
          patent_index = ::PatentUtils.index(patent_raw: patent_raw)
          if patent_index.valid?
            patent_raw.converted!
          else
            patent_raw.cancel!
          end  
        rescue Exception => e
          patent_raw.cancel!
          ::ErrorReporter.report(e)
        end
      end
  end
end
