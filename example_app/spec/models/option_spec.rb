require 'spec_helper'

describe Option do
  it { should validate_presence_of(:text) }

  it { should belong_to(:question) }
end
