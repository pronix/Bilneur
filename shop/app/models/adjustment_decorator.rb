Adjustment.class_eval do
  belongs_to :seller, :class_name => "User"
end
