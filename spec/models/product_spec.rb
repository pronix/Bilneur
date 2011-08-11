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

    it "get best variant" do
      @seller = Factory.create(:user, :registration_as_seller => 1)
      @product = Factory.create(:product, { :ean => "B004GVYJJC", :owner =>  @seller })
      common_options = { :product => @product, :condition => "new", :seller => @seller }
      @variant1 = Factory.create(:variant, common_options.merge({:price => 7.00, :count_on_hand => 1, :sku => "S1"}))
      @variant2 = Factory.create(:variant, common_options.merge({:price => 7.23, :count_on_hand => 1, :sku => "S2"}))
      @variant3 = Factory.create(:variant, common_options.merge({:price => 6.23, :count_on_hand => 0, :sku => "S3"}))
      @variant4 = Factory.create(:variant, common_options.merge({:price => 6.43, :count_on_hand => 1, :sku => "S4"}))
      @product.best_variant.should eq(@variant4)
    end

    it "fill default data for create" do
      @seller = Factory.create(:user, :registration_as_seller => 1)
      @product = Factory.create(:product, { :ean => "B004GVYJJC", :owner =>  @seller })
      @product.price.should_not be_nil
      @product.available_on.should_not be_nil
    end

  end

end
