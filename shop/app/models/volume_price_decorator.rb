VolumePrice.class_eval do
  before_validation :start_end_2_range
  attr_accessor :start_range, :end_range


  def validate
    return if open_ended?
    errors.add(:range, "You should at least indicate the start range") unless /\([0-9]+\.{2,3}[0-9]+\)/ =~ range
  end

  def start_range
    read_attribute(:start_range) || split_range[0]
  end

  def start_range=(value)
    write_attribute(:start_range, value)
  end

  def end_range
    read_attribute(:end_range) || split_range[1]
  end

  def end_range=(value)
    write_attribute(:end_range, value)
  end

  # For write value to range
  def start_end_2_range
    if !start_range.blank? && !end_range.blank?
      self.range = "(#{start_range}..#{end_range})"
      self.display = "#{start_range} to #{end_range}"
    elsif start_range && end_range.blank?
      self.range = "(#{start_range}+)"
      self.display = "#{start_range} and more"
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
