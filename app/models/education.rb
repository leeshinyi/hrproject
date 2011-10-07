class Education < ActiveRecord::Base
  belongs_to :applicant

  has_many :educations
  belongs_to :school
  
  validates :school_id, :school_name, :course, :years_attended, :presence => true
end
