VolumePrice.class_eval do
  before_validation :start_end_2_range
  attr_accessor :start_r, :end_r


  def validate
    return if open_ended?
    errors.add(:range, "You should at least indicate the start range") unless /\([0-9]+\.{2,3}[0-9]+\)/ =~ range
  end

  # For read value from range
  def start_range
    split_range[0]
  end

  def end_range
    split_range[1]
  end

  # For write value to range
  def start_end_2_range
    if !start_r.blank? && !end_r.blank?
      self.range = "(#{start_r}..#{end_r})"
      self.display = "#{start_r} to #{end_r}"
    elsif start_r && end_r.blank?
      self.range = "(#{start_r}+)"
      self.display = "#{start_r} and more"
    end
  end

  def split_range
    if range =~ /(\d+)\+/
      return [$1.to_i, nil]
    elsif range =~ /(\d+)\.{2}(\d+)/
      return [$1.to_i, $2.to_i]
    elsif range =~ /(\d+)\.{3}(\d+)/
      return [$1.to_i + 1, $2.to_i - 1]
    else
      []
    end
  end


end
