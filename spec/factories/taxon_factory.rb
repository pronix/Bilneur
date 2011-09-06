Factory.define(:taxon) do |record|
  record.name "Ruby on Rails"
  record.taxonomy { Factory(:taxonomy) }
  #record.parent  { Factory(:categories) }
end
