require 'spec_helper'

describe Unsubscribe do
  it { should validate_presence_of(:email) }
end
