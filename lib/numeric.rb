class Numeric
  def duration
    secs  = self.to_int
    mins  = secs / 60
    hours = mins / 60
    days  = hours / 24

    if days > 0
      "#{days} days #{hours % 24} hrs"
    elsif hours > 0
      "#{hours} hrs #{mins % 60} min."
    elsif mins > 0
      "#{mins} min. #{secs % 60} sec."
    elsif secs >= 0
      "#{secs} sec."
    end
  end
end