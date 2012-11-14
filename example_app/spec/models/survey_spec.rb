require 'spec_helper'

describe Survey do
  it { should validate_presence_of(:title) }
  it { should have_many(:questions) }
end
