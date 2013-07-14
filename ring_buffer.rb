class RingBuffer < Array

  def initialize( size )
    @ring_size = size
    super( size )
  end

  def push( element )
    if length == @ring_size
      shift # loose element
    end
    super element
  end
end
