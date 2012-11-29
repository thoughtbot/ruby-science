class User < ActiveRecord::Base
  include Clearance::User

  def full_name
    "#{first_name} #{last_name}"
  end
end
