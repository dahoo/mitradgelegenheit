class Start < WayPoint
  def index
    track.starts.index(self).try(:+, 1) if track
  end
end
