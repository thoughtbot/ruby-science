describe OpenSubmittable, '#score' do
  it 'returns zero' do
    submittable = OpenSubmittable.new

    result = submittable.score('anything')

    result.should eq 0
  end
end
