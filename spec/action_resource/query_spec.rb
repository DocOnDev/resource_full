require File.dirname(__FILE__) + '/../spec_helper'

describe "ActionResource::Query", :type => :controller do
  controller_name "users"
  
  before :each do
    User.delete_all
    @users = [
      User.create!(:address_id => 1, :income => 70_000),
      User.create!(:address_id => 1, :income => 30_000),
      User.create!(:address_id => 2, :income => 70_000),
    ]
  end
  attr_reader :users
  
  it "isn't queryable on any parameters by default" do
    controller.class.queryable_params.should be_empty
  end
  
  it "allows you to specify queryable parameters" do
    controller.class.queryable_with :address_id, :income
    controller.class.queryable_params.should include(:address_id, :income)
  end
  
  it "retrieves objects based on a queried condition" do
    controller.class.queryable_with :address_id
    get :index, :address_id => 1
    assigns(:users).should include(users[0], users[1])
    assigns(:users).should_not include(users[2])
  end
  
  it "retrieves no objects if the queried condition is not matched" do
    controller.class.queryable_with :address_id
    get :index, :address_id => 3
    assigns(:users).should be_empty
  end
  
  it "retrieves objects based on multiple queried conditions" do
    controller.class.queryable_with :address_id, :income
    get :index, :address_id => 1, :income => 70_000
    assigns(:users).should == [ users[0] ]
  end
  
  it "retrieves objects based on lists of queried conditions" do
    controller.class.queryable_with :address_id, :income
    get :index, :address_id => "1,2"
    assigns(:users).should include(*users)
  end
  
  it "retrieves objects given pluralized forms of queryable parameters" do
    controller.class.queryable_with :address_id
    get :index, :address_ids => "1,2"
    assigns(:users).should include(*users)
  end
  
  it "inherits queryable settings from its superclass"

end