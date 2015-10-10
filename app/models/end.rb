class End < WayPoint
  def index
    track.ends.index(self).try(:+, 1) if track
  end
end
