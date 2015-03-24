require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end

    # Test for Follower stats
    follower_count = @user.followers.count
    assert_select 'strong[id="followers"]', text: follower_count.to_s

    # Test for following stats
    assert_select 'strong[id="following"]', text: @user.following.count.to_s

    get root_path
    assert_template 'static_pages/home'

    # Test for Follower stats
    follower_count = @user.followers.count
    assert 'strong[id="followers"]', { count: 0, text: follower_count.to_s }

    # Test for following stats
    assert 'strong[id="following"]', text: @user.following.count.to_s

  end

end
