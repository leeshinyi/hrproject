class Applicant < ActiveRecord::Base
  belongs_to :source
  has_many :educations
  has_many :work_experiences
  has_many :pending_applications
  has_many :families
  has_many :references
  has_many :questions, :through => :qandas

  accepts_nested_attributes_for :educations, :reject_if => lambda { |a| a[:school].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :work_experiences, :reject_if => lambda { |a| a[:employer].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :families, :allow_destroy => true
  accepts_nested_attributes_for :references, :allow_destroy => true


  validates :first_name, :middle_name, :last_name, :email, :presence => true
  validates :email, :uniqueness => true
  validates :email, :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }

  attr_accessible :source_id, :other_source, :first_name, :middle_name, :last_name, :gender, :civil_status, :street, :city, 
                  :region, :zip, :birthdate, :landline, :mobile, :email, :sss, :philhealth, :pagibig, 
                  :tin, :other_skills, :abroad_plans, :how_soon, :emergency_contact, :emergency_address, 
                  :emergency_phone, :date_available_for_work, :desired_salary_range, :date_of_application,
                  :other_observations, :educations_attributes, :families_attributes, :work_experiences_attributes

  attr_writer :current_step

  def current_step
    @current_step || steps.first
  end

  def steps
    %w[personal_info education work_experience family_background]
  end

  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end

  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end
end
