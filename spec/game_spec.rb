require 'spec_helper'

describe Game do
  let(:klass) { described_class }
  let(:instance) { klass.new }

  it { klass.should be_instance_of Class }

  # For testing purposes, we don't want our thread to enter a game loop.
  before(:all) { DesktopWindow.class_eval "def each_tick; yield; end" }

  describe '#context' do
    subject { instance.context }
    it { should be_nil }
  end

  describe '#resolution' do
    subject { instance.resolution }
    it { should eq V[320, 180] }
  end

  describe '#resolution=' do
    subject { instance.method(:resolution=) }
    it_behaves_like 'writer', V[512, 384]
  end

  describe '#update' do
    before { instance.map = Map.new }

    it "calls #map's update" do
      instance.map.should receive(:update)
      instance.send(:update)
    end
  end

  describe '#render' do
    before do
      instance.map = Map.new
      surface = Surface.new(V[10, 10])
    end

    context "after start" do
      before { instance.start }

      it "renders map's render" do
        instance.map.stub(:render).and_return("the map")
        instance.context.should receive(:render).with("the map")
        instance.send(:render)
      end
    end
  end

  describe '#map' do
    subject { instance.map }

    it { should be_nil }
  end

  describe '#map=' do
    subject { instance.method(:map=) }

    it_behaves_like 'writer', Map.new

    it "sets map's game as self" do
      instance.map = Map.new
      instance.map.game.should eq instance

      instance.map = instance.map
    end

    it "does not set map's game as self twice" do
      instance.map = Map.new
      instance.map.should_not receive(:game=)

      instance.map = instance.map
    end
  end

  describe '#start' do
    it "instantiates a DesktopBackend for #context" do
      instance.start
      instance.context.should be_instance_of DesktopWindow
    end

    it "calls #context#each_tick with a block with #update and #render calls" do
      instance.should receive(:update)
      instance.should receive(:render)
      instance.start
    end
  end

  describe '#stop' do
    it "makes #screen nil" do
      instance.start
      instance.stop
      instance.context.should be_nil
    end

    it "breaks out of #update/#render loop initialized by #start" do
      instance.instance_eval "def update; stop; end"
      instance.should receive(:render).once
      instance.start
    end
  end
end
