require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  	def setup
		@user = users(:michael)
	end

	test "layout links" do
		get root_path
		assert_template 'static_pages/home'
		assert_select "a[href=?]", root_path, count: 2
		assert_select "a[href=?]", help_path
		assert_select "a[href=?]", about_path
		assert_select "a[href=?]", contact_path
		get signup_path
    	assert_select "title", full_title("Sign up")
	end

	test "user login navigation links" do
		get login_path
		assert_select "a[href=?]", login_path
		
		log_in_as(@user)
		assert is_logged_in?
		assert_redirected_to @user
		follow_redirect!
		
		assert_template 'users/show'
		assert_select "a[href=?]", login_path, count: 0
		assert_select "a[href=?]", logout_path
		assert_select "a[href=?]", user_path(@user)
		
		delete logout_path
		assert_not is_logged_in?
		assert_redirected_to root_url

		follow_redirect!
		assert_select "a[href=?]", login_path
		assert_select "a[href=?]", logout_path, count: 0
	end
end
