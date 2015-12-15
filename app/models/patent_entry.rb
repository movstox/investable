class PatentEntry < ActiveRecord::Base
  belongs_to :institution
  state_machine :initial => :new do
    # states to be defined
    event :scrape do
      transition :new => :scraped
    end

    event :cancel do
      transition any => :cancelled
    end
  end
end
