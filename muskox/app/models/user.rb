class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  #   string :first_name
  #   string :last_name
  #   string :organization
  #   text :biography
  #   string :job_title
  #   string :email
  
  validates :first_name, :last_name, :organization, :biography, :job_title, :email, presence: true
  
  validates :biography, length: { minimum: 120, maximum: 400, too_short: "%{count} characters is too short, you need at least 120 characters", too_long: "%{count} characters is too long, you need to keep it under 400 characters" }
  
  validates :email, uniqueness: true
  
end
