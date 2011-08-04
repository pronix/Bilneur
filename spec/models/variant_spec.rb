require 'spec_helper'

describe Variant do
  before(:all){
    Product.destroy_all
    User.destroy_all
    Variant.destroy_all
  }

  describe "validation" do

    describe "of associated seller" do

      before(:each){
        @seller = Factory.create(:user, :registration_as_seller => 1)
        @product = Factory.create(:product, { :ean => "B004GVYJJC", :owner =>  @seller })

      }

      it "fails if seller is null" do
        @variant = Factory.build(:variant, :product => @product, :condition => "new")
        @variant.should_not be_valid
        @variant.errors[:seller].count.should eq(1)
        @variant.errors.full_messages.first.should =~ /Seller can't be blank/i
      end

      it "passes if seller is not null" do
        Factory.build(:variant, :seller => @seller, :product => @product, :condition => "new").should be_valid
      end

    end

    describe "Condition" do

      before(:each){
        @seller = Factory.create(:user, :registration_as_seller => 1)
        @product = Factory.create(:product, { :ean => "B004GVYJJC", :owner =>  @seller })
      }

      it "fails if condition blank" do
        @variant = Factory.build(:variant, :product => @product, :seller => @seller)
        @variant.should_not be_valid
        @variant.errors[:condition].count.should eq(1)
        @variant.errors.full_messages.first.should =~ /Condition is not included in the list/i
      end

      it "fails if condition not inclusion in (new used)" do
        @variant = Factory.build(:variant, :product => @product, :condition => "trash", :seller => @seller)
        @variant.should_not be_valid
        @variant.errors[:condition].count.should eq(1)
        @variant.errors.full_messages.first.should =~ /Condition is not included in the list/i
      end

      it "pass if condition is valid" do
        @variant = Factory.build(:variant, :product => @product, :condition => "new", :seller => @seller)
        @variant.should be_valid
      end
    end

    describe "Count on Hand" do
      before(:each){
        @seller = Factory.create(:user, :registration_as_seller => 1)
        @product = Factory.create(:product, { :ean => "B004GVYJJC", :owner =>  @seller })
      }

      it "fails if count is negative number" do
        @variant = Factory.build(:variant,
                                 :product => @product, :condition => "new",
                                 :seller => @seller, :count_on_hand => -1)
        @variant.should_not be_valid
      end

      it "pass if count is valid number" do
        @variant = Factory.build(:variant,
                                 :product => @product, :condition => "new",
                                 :seller => @seller, :count_on_hand => 1)
        @variant.should be_valid

      end
    end

    describe "Price" do
      before(:each){
        @seller = Factory.create(:user, :registration_as_seller => 1)
        @product = Factory.create(:product, { :ean => "B004GVYJJC", :owner =>  @seller })
      }

      it "fails if price is negative number" do
        @variant = Factory.build(:variant,
                                 :product => @product, :condition => "new",
                                 :seller => @seller, :price => -1)
        @variant.should_not be_valid
      end

      it "fails if price is zero number" do
        @variant = Factory.build(:variant,
                                 :product => @product, :condition => "new",
                                 :seller => @seller, :price => 0)
        @variant.should_not be_valid
      end

      it "pass if price is valid number" do
        @variant = Factory.build(:variant,
                                 :product => @product, :condition => "new",
                                 :seller => @seller, :price => 1.99)
        @variant.should be_valid
      end

    end


  end

  it "marking for deletion" do
    @seller = Factory.create(:user, :registration_as_seller => 1)
    @product = Factory.create(:product, { :ean => "B004GVYJJC", :owner =>  @seller })
    @variant = Factory.create(:variant, :product => @product, :condition => "new", :seller => @seller)
    @variant.mark_deletion!
    @variant.deleted?.should be_true
  end

  describe "Description quote" do

    it "read varinat description if then define in variant" do
      @seller = Factory.create(:user, :registration_as_seller => 1)
      @product = Factory.create(:product, { :ean => "B004GVYJJC", :owner =>  @seller, :description => "product_description" })
      @variant = Factory.create(:variant, :product => @product,
                                :condition => "new", :seller => @seller, :description => "varinat_description")
      @variant.description.should eq("varinat_description")
    end
    it "read varinat description if then define in product" do
      @seller = Factory.create(:user, :registration_as_seller => 1)
      @product = Factory.create(:product, { :ean => "B004GVYJJC", :owner =>  @seller, :description => "product_description" })
      @variant = Factory.create(:variant, :product => @product, :condition => "new", :seller => @seller)
      @variant.description.should eq("product_description")

    end
    it "write" do
      @seller = Factory.create(:user, :registration_as_seller => 1)
      @product = Factory.create(:product, { :ean => "B004GVYJJC", :owner =>  @seller, :description => "product_description" })
      @variant = Factory.create(:variant, :product => @product, :condition => "new", :seller => @seller)
      @variant.description = "new_product_description"
      @variant.save
      @variant.description.should eq("new_product_description")

    end
  end

  describe "Name quote" do
    it "read varinat name if then define in variant" do
      @seller = Factory.create(:user, :registration_as_seller => 1)
      @product = Factory.create(:product, { :ean => "B004GVYJJC", :owner =>  @seller, :name => "product_name" })
      @variant = Factory.create(:variant, :product => @product, :condition => "new", :seller => @seller, :name => "varinat_name")
      @variant.name.should eq("varinat_name")
    end
    it "read varinat name if then define in product" do
      @seller = Factory.create(:user, :registration_as_seller => 1)
      @product = Factory.create(:product, { :ean => "B004GVYJJC", :owner =>  @seller, :name => "product_name" })
      @variant = Factory.create(:variant, :product => @product, :condition => "new", :seller => @seller)
      @variant.name.should eq("product_name")

    end
    it "write" do
      @seller = Factory.create(:user, :registration_as_seller => 1)
      @product = Factory.create(:product, { :ean => "B004GVYJJC", :owner =>  @seller, :name => "product_name" })
      @variant = Factory.create(:variant, :product => @product, :condition => "new", :seller => @seller)
      @variant.name = "new_product_name"
      @variant.save
      @variant.name.should eq("new_product_name")
    end


  end



end
