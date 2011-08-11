require 'spec_helper'

describe Product do
  before(:all){
    Product.destroy_all
    User.destroy_all
  }

  describe "validation" do
    describe "of associated owner" do
      it "fails if owner is null" do
        @product = Factory.build(:product, { :ean => "B004GVYJJC"})
        @product.should_not be_valid
        @product.errors[:owner].count.should eq(1)
        @product.errors.full_messages.first.should =~ /Owner can't be blank/i
      end

      it "pass if owner is not null" do

        @product = Factory.build(:product, { :ean => "B004GVYJJC",
                                   :owner =>  Factory.create(:user, :registration_as_seller => 1) })
        @product.should be_valid
      end

    end

    describe "of EAN" do

      it "requires presence" do
        @product = Factory.build(:product, :owner =>  Factory.create(:user, :registration_as_seller => 1))
        @product.should_not be_valid
        @product.errors[:ean].count.should eq(1)
        @product.errors.full_messages.first.should =~ /EAN can't be blank/i
      end

      it "requires uniqueness" do
        @product = Factory.create(:product, { :ean => "B004GVYJJC",
                                   :owner =>  Factory.create(:user, :registration_as_seller => 1)})
        @product1 = Factory.build(:product, { :ean => "B004GVYJJC",
                                    :owner =>  Factory.create(:user, :registration_as_seller => 1)})

        @product1.should_not be_valid
        @product1.errors[:ean].count.should eq(1)
        @product1.errors.full_messages.first.should =~ /EAN has already been taken/i

      end

    end
  end

  describe "instance methods" do
    # FIXIT
    # it "get best variant" do
    #   @seller = Factory.create(:user, :registration_as_seller => 1)
    #   @product = Factory.create(:product, { :ean => "B004GVYJJC", :owner =>  @seller })
    #   common_options = { :product => @product, :condition => "new", :seller => @seller }
    #   @variant1 = Factory.create(:variant, common_options.merge({:price => 7.00, :count_on_hand => 1}))
    #   @variant2 = Factory.create(:variant, common_options.merge({:price => 7.23, :count_on_hand => 1}))
    #   @variant3 = Factory.create(:variant, common_options.merge({:price => 6.23, :count_on_hand => 0}))
    #   @variant4 = Factory.create(:variant, common_options.merge({:price => 6.43, :count_on_hand => 1}))
    #   @product.best_variant.should eq(@variant4)
    # end

    it "fill default data for create" do
      @seller = Factory.create(:user, :registration_as_seller => 1)
      @product = Factory.create(:product, { :ean => "B004GVYJJC", :owner =>  @seller })
      @product.price.should_not be_nil
      @product.available_on.should_not be_nil
    end
  end

  describe "Top products" do
    it "should see top products by user rating", :top_products => true do
      # Create a sample user
      @user = Factory.create(:user, :registration_as_seller => 1)
      # Create a sample product
      for i in 1..11 do
        # Factory(:variant, {:product => })
        product = Factory(:product, { :ean => "B004GVYJJ#{i}", :owner => @user})
        variant = Factory(:variant, {:product => product, :seller => @user, :condition => "used", :count_on_hand => 10})
        # Create a random reviews to product and assigning random rating
        1.upto(rand(10)) do
          product.reviews.create(:name => 'test', :review => 'test', :approved => true, :rating => rand(5))
        end
        # Recalculate avg_rating and review_count
        product.recalculate_rating
      end
      # I always forget aboud who's who DESC and ASC
      # REMEMBER: DESC(10..1), ASC(1..1)
      Product.tops.each do |product|
        @new_product = product
        @last_product = @new_product and next if @last_product.nil?
        # puts "#{@last_product.avg_rating.to_i} >= #{@new_product.avg_rating.to_i}"
        (@last_product.avg_rating.to_i >= @new_product.avg_rating.to_i).should be true
        @last_product = @new_product
      end
      Product.tops.count.should == 10
    end
  end

end
