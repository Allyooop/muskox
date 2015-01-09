class User < ActiveRecord::Base
  #   string :first_name
  #   string :last_name
  #   string :organization
  #   text :biography
  #   string :job_title
  #   string :email
  
  validates :first_name, :last_name, :organization, :biography, :job_title, :email, presence: true
  
  validates :biography, length: { minimum: 120, too_short: "%{count} characters is too short, you need at least at least 120 characters" }
  
end
