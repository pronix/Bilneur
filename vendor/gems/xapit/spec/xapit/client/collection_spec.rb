require "spec_helper"

describe Xapit::Client::Collection do
  it "builds up clauses with in_classes, search, where, order calls" do
    collection1 = Xapit::Client::Collection.new([:initial])
    collection2 = collection1.in_classes(String).search("hello").where(:foo => "bar").order(:bar)
    collection1.clauses.should eq([:initial])
    collection2.clauses.should eq([:initial, {:in_classes => [String]}, {:search => "hello"}, {:where => {:foo => "bar"}}, {:order => [:bar, :asc]}])
  end

  it "returns same collection when searching nil or empty string" do
    collection1 = Xapit::Client::Collection.new
    collection1.search("").should eq(collection1)
    collection1.search(nil).should eq(collection1)
    collection1.search.should eq(collection1)
  end

  it "returns indexed records and delegates array methods to it" do
    load_xapit_database
    member = XapitMember.new
    member.class.xapit_index_builder.add_document(member)
    collection = Xapit::Client::Collection.new
    collection.records.should eq([member])
    collection.should respond_to(:flatten)
    collection.flatten.should eq([member])
  end

  it "splits up matching facets into an array" do
    collection = Xapit::Client::Collection.new.with_facets("foo-bar")
    collection.clauses.should eq([{:with_facets => %w[foo bar]}])
  end

  it "splits range into from/to hash" do
    collection = Xapit::Client::Collection.new.where(:priority => 3..5)
    collection.clauses.should eq([{:where => {:priority => {:from => 3, :to => 5}}}])
  end

  it "does not raise an exception when passing nil to with_facets" do
    lambda {
      Xapit::Client::Collection.new.with_facets(nil).should be_kind_of(Xapit::Client::Collection)
    }.should_not raise_exception
  end

  it "defaults to 20 per page and page 1" do
    Xapit::Client::Collection.new.limit_value.should eq(20)
    Xapit::Client::Collection.new.current_page.should eq(1)
  end

  it "supports kaminari pagination" do
    collection = Xapit::Client::Collection.new.page("2").per("10")
    collection.stub(:total_entries) { 29 }
    collection.current_page.should eq(2)
    collection.num_pages.should eq(3)
    collection.limit_value.should eq(10)
  end

  it "supports will_paginate pagination" do
    collection = Xapit::Client::Collection.new.page("2").per("10")
    collection.stub(:total_entries) { 29 }
    collection.current_page.should eq(2)
    collection.total_pages.should eq(3)
  end
end
