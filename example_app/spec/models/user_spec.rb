require 'spec_helper'

describe User, '#full_name' do
  it 'returns the users full name' do
    user = User.new(first_name: 'First', last_name: 'Last')

    user.full_name.should eq('First Last')
  end
end
