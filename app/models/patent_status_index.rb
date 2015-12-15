class PatentStatusIndex < ActiveRecord::Base
  validates :status, presence: true
end
