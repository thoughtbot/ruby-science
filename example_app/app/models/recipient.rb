class Recipient < Struct.new(:first_name, :last_name, :email)
  def full_name
    "#{first_name} #{last_name}"
  end
end