class PatentRaw < ActiveRecord::Base
  belongs_to :patent_entry
  belongs_to :institution
  has_one :patent_index
  validates :patent_entry_id, presence: true
  state_machine :initial => :new do
    # states to be defined
    event :converted do
      transition :new => :converted
    end

    event :cancel do
      transition any => :cancelled
    end

    event :retry do
      transition any => :new
    end
  end
end
