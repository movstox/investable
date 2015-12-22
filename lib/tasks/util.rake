namespace :util do

  task :sync_all => :environment do
    Rake::Task["ucsf:sync"].invoke
    Rake::Task["stanford:sync"].invoke
    Rake::Task["berkeley:sync"].invoke
  end

  task :scrape_all => :environment do
    Rake::Task["ucsf:scrape"].invoke
    Rake::Task["stanford:scrape"].invoke
    Rake::Task["berkeley:scrape"].invoke
  end

  task :clean_index => :environment do
    [
      PatentIndex,
      StageOfResearchIndex,
      PatentStatusIndex
    ].map(&:destroy_all)

    # clean up keywords and inventors
    ActiveRecord::Base.connection.execute('delete from taggings')
    ActiveRecord::Base.connection.execute('delete from tags')

    PatentRaw.all.map(&:retry!)
  end

  task :rebuild_index => :environment do
    Rake::Task["util:clean_index"].invoke
    Rake::Task["ucsf:index"].invoke
    Rake::Task["stanford:index"].invoke
    Rake::Task["berkeley:index"].invoke
  end
end
