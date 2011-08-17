# make sure the product images directory exists
FileUtils.mkdir_p "#{Rails.root}/public/assets/products/"

Asset.all.each do |asset|
  filename = asset.attachment_file_name
  puts "-- Processing image: #{filename}\r"
  path = File.join(File.dirname(__FILE__), "assets/#{filename}")

  if FileTest.exists? path
    asset.attachment = File.open(path)
    asset.save
  else
    puts "--- Could not find image at: #{path}"
  end
end
# Create avg_rating and reviews_count
Product.all.each { |product| product.recalculate_rating }
books = Taxon.find_by_name "Books"
product = Product.find_by_name "Breakfast At Tiffany's"
product.taxons << books

product = Product.find_by_name "The Godfather - The Coppola Restoration"
product.taxons << books

product = Product.find_by_name "Death of a Hero [Paperback]"
product.taxons << books

laptops = Taxon.find_by_name "Laptops & Desktops"

product = Product.find_by_name "Lenovo Thinkpad T410s"
product.taxons << laptops

product = Product.find_by_name "compaq nc6000 P-M 1.6 GHz 512M/40G 14.1"
product.taxons << laptops

product = Product.find_by_name "VGN-CS21S/T"
product.taxons << laptops



