module StringExtensions
  def possessive
    return self if self.empty?
    s = I18n.locale == :de ? "s" : "'s"
    self + ((%w{x s z ß}.include? self[-1]) ? "'" : s)
  end
end

class String
  include StringExtensions
end