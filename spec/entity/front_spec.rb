describe Entity, '#front' do
  it { subject.front.should eq 0 }

  context "with area" do
    before do
      subject.area = Area.new
      subject.position = V[10, 10, 10]
      subject.size = V[4, 2, 8]
    end

    it "is z of front edge within area based on anchor" do
      subject.anchor[2] = 0
      subject.front.should eq 18

      subject.anchor[2] = 1
      subject.front.should eq 10

      subject.anchor[2] = 0.5
      subject.front.should eq 14
    end
  end
end