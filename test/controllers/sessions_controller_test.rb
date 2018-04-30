require "test_helper"

describe SessionsController do
  describe "auth_callback" do
    it "logs in an existing user" do
      old_user_count = User.count
      user = users(:kari)

      login(user)

      User.count.must_equal old_user_count

      must_redirect_to root_path
      session[:user_id].must_equal user.id
      must_respond_with :redirect
    end

    it "creates a new user if one does not already exist" do
      old_user_count = User.count

      user = User.new(
        provider: "github",
        uid: 333333,
        username: "anne_test",
        email: "anne@anne.com"
      )

      login(user)

      must_redirect_to root_path

      User.count.must_equal old_user_count + 1
      session[:user_id].must_equal User.last.id
    end
  end
end
