require 'spec_helper'

describe User, '#full_name' do
  it 'returns the users full name' do
    user = User.new(first_name: 'First', last_name: 'Last')

    expect(user.full_name).to eq 'First Last'
  end
end
