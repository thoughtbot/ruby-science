require 'spec_helper'

describe EnumerableValidator, '#validate_each' do
  it 'add errors for each invalid item' do
      record = build_record(['valid@example.com', 'invalidOne', 'invalidTwo'])

      EnumerableValidator.new(
        attributes: :emails,
        validator: EmailValidator
      ).validate(record)

      record.errors.full_messages.should eq [
        'Emails invalidOne is not a valid email',
        'Emails invalidTwo is not a valid email',
      ]
  end

  def build_record(emails)
    example_class.new.tap do |o|
      o.emails = emails
    end
  end

  def example_class
    Class.new do
      include ActiveModel::Validations
      attr_accessor :emails

      def self.name
        'TestClass'
      end
    end
  end
end
