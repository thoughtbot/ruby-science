require 'spec_helper'

describe Message do
  it { should belong_to(:recipient) }
  it { should belong_to(:sender) }

  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:recipient_id) }
  it { should validate_presence_of(:sender_id) }
end
