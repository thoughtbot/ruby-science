require 'spec_helper'

describe EmailValidator, '#validate_each' do
  it 'adds errors when given invalid email' do
    record = build_record('invalid_email')
    EmailValidator.new(attributes: :email).validate(record)

    record.errors.full_messages.should eq [
      'Email invalid_email is not a valid email'
    ]
  end

  it 'does not add errors when given valid email' do
    record = build_record('valid@example.com')
    EmailValidator.new(attributes: :email).validate(record)

    record.errors.should be_empty
  end

  def build_record(email)
    example_class.new.tap do |o|
      o.email = email
    end
  end

  def example_class
    Class.new do
      include ActiveModel::Validations
      attr_accessor :email

      def self.name
        'TestClass'
      end
    end
  end
end
