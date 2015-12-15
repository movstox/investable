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
end
