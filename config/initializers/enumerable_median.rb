module Enumerable
  def median
    # trivial cases
    return nil if self.empty?

    mid = self.length / 2
    if self.length.odd?
      (entries.sort)[mid]
    else
      s = entries.sort
      (s[mid-1] + s[mid]).to_f / 2.0
    end
  end
end