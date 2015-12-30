require 'test_helper'

class UserTest < ActiveSupport::TestCase
  	
	def setup
		@user = User.new(name: "Example User", email: "user@example.com",
											password: "foobar", password_confirmation: "foobar")
	end


	test "should be valid" do 
		assert @user.valid?
	end

	test "name present" do
		@user.name = "  "
		assert_not @user.valid?
	end

	test "enforce name length" do
		@user.name = "a" * 51
		assert_not @user.valid?
	end

	test "email present" do
		@user.email = "  "
		assert_not	@user.valid?
	end

	test "enforce email length" do
		@user.email = "a" * 244 + "@example.com"
		assert_not @user.valid?
	end

	test "email validation" do
		invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com]

		invalid_addresses.each do |invalid_address|
			@user.email = invalid_address
			assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
		end

	end

	test "email is unique" do
		duplicate_user = @user.dup
		duplicate_user.email = @user.email.upcase
		@user.save
		assert_not	duplicate_user.valid?
	end	

	test "password minimum length" do
		@user.password = @user.password_confirmation = "a" * 5
		assert_not @user.valid?
	end


end