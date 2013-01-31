describe ScaleSubmittable, '#score' do
  it 'returns the integer value of the text' do
    submittable = ScaleSubmittable.new

    result = submittable.score('5')

    result.should eq 5
  end
end
