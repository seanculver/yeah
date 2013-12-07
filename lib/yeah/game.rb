# Manages entities.
class Yeah::Game
  include Yeah

  def initialize
    @resolution = V[320, 180]
    @surface = Surface.new(@resolution)
  end

  # @!attribute [r] backend
  #   @return [Platform] platform bindings
  attr_reader :backend

  attr_reader :map
  def map=(value)
    @map = value
    @map.game = self unless @map.game == self
  end

  # @!attribute resolution
  #   @return [Vector] size of screen
  attr_accessor :resolution

  # Start the game loop.
  def start
    @backend = DesktopBackend.new

    backend.each_tick do
      update
      draw
      break if @stopped
    end
  end

  # Stop the game loop.
  def stop
    @backend = nil
    @stopped = true
  end

  def update
    @map.update if @map
  end

  def draw
    backend.render(@map.draw) if @map
  end

  protected :update, :draw
end
