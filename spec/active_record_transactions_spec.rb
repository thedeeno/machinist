require File.dirname(__FILE__) + '/spec_helper'
require 'support/active_record_environment'

describe Machinist::ActiveRecord do
  include ActiveRecordEnvironment

  def fake_a_test
    ActiveRecord::Base.transaction do
      Machinist.reset_before_test
      yield
      raise ActiveRecord::Rollback
    end
  end

  context "ActiveRecord::Rollback" do
    it "should clean the database of machinist artifacts" do
      Post.blueprint { }
      Post.all.count.should == 0
      fake_a_test { Post.make! }
      fake_a_test { Post.make! }
      fake_a_test { Post.make! }
      Post.all.count.should == 0
    end
  end
end
