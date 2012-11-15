require 'spec_helper'

describe Answer do
  it { should belong_to(:completion) }
  it { should belong_to(:question) }

  it { should validate_presence_of(:text) }
end
