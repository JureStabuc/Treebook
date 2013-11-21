require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_many(:user_friendships)
  should have_many(:friends)

  test "a user should enter a first name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:first_name].empty?
  end

  test "a user should enter a last name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:last_name].empty?
  end

  test "a user should enter a profile name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end

  test "a user should have a unique profile name" do
  	user = User.new
  	user.profile_name = users(:jure).profile_name
  	
  

  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end

  test "a user should have a profile name without spaces" do
  	user = User.new(first_name: 'Jure', last_name: 'Stabuc', email: 'jure.stabuc@gmail.com')
    user.password = user.password_confirmation = "1141988jure"

  	user.profile_name = "My Profile With Spaces"

  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  	assert user.errors[:profile_name].include?("Must be formatted correctly.")
  end

  test "a user can have a correctly formatted profile name" do
    user = User.new(first_name: 'Jure', last_name: 'Stabuc', email: 'jure.stabuc@gmail.com')
    user.password = user.password_confirmation = "1141988jure"

    user.profile_name = 'juresta'
    assert user.valid?
  end

  test "That no error is raised when trying to access a friend list" do
    assert_nothing_raised do
      users(:jure).friends
    end
  end

  test "thath creating friendships on a user works" do
    users(:jure).pending_friends << users(:mike)
    users(:jure).pending_friends.reload
    assert users(:jure).pending_friends.include?(users(:mike))
  end

  test "that calling to_param on a user returns the profile_name" do
    assert_equal "juresta", users(:jure).to_param
  end
end
