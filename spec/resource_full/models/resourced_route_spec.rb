require File.dirname(__FILE__) + '/../../spec_helper'

module ResourceFull
  module Models
    
    describe ResourcedRoute do
      it "has a verb, name, pattern, and action" do
        ResourcedRoute.new(:verb => "GET").verb.should == "GET"
        ResourcedRoute.new(:name => "users").name.should == "users"
        ResourcedRoute.new(:pattern => "/users").pattern.should == "/users"
        ResourcedRoute.new(:action => "index").action.should == "index"
      end
      
      it "has an associated controller derived from the given string" do
        ResourcedRoute.new(:controller => "resource_full_mock_users").controller.should == ResourceFullMockUsersController
      end
      
      it "has an associated controller derived from the given class" do
        ResourcedRoute.new(:controller => ResourceFullMockUsersController).controller.should == ResourceFullMockUsersController
      end
      
      it "should know if it's a formatted route" do
        ResourcedRoute.new(:name => "formatted_resource_full_mock_users").should be_formatted
      end
      
      it "should know if it's a resourced route" do
        ResourcedRoute.new(:resource => nil).should_not be_resourced
      end
      
      it "should know how to look up its resource" do
        ResourcedRoute.new(:controller => ResourceFullMockUsersController).resource.should == "resource_full_mock_user"
      end
  
      describe "query" do
        it "raises an exception when it can't find a particular route" do
          lambda do 
            ResourcedRoute.find("this route does not exist")
          end.should raise_error(ResourceFull::Models::RouteNotFound)
        end
        
        it "locates a particular named route" do
          route = ResourcedRoute.find :resource_full_mock_users
          route.pattern.should == "/resource_full_mock_users/"
          route.verb.should == "GET"
          route.action.should == "index"
          route.controller.should == ResourceFullMockUsersController
        end
        
        it "locates all named routes"
      end
    end
  end
end