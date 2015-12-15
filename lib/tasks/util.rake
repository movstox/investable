namespace :util do
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
