class PatentRaw < ActiveRecord::Base
  belongs_to :patent_entry
  validates :patent_entry_id, presence: true
  state_machine :initial => :new do
    # states to be defined
    event :converted do
      transition :new => :converted
    end

    event :cancel do
      transition any => :cancelled
    end
  end
end
