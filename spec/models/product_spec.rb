require 'spec_helper'

describe Product do
  # before(:all){ Product.destroy_all}

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
                                   :owner =>  Factory.create(:user, :registration_as_seller => 1)})
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
end
