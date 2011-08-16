Calculator::FlexiRate.class_eval do
  def compute(object, *args)
    sum = 0
    max = self.preferred_max_items
    items_count = object.line_items.map(&:quantity).sum
    items_count.times do |i|
      if (i % max == 0) && (max > 0)
        sum += self.preferred_first_item
      else
        sum += self.preferred_additional_item
      end
    end
    return(sum)
  end

end
