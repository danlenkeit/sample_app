require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
	test "full title helper" do
		assert_equal full_title, "DLEN CHILL"
		assert_equal full_title("ABOUT"), "DLEN CHILL||ABOUT"
		assert_equal full_title("CONTACT"), "DLEN CHILL||CONTACT"
		assert_equal full_title("HELP"), "DLEN CHILL||HELP"
		assert_equal full_title("SIGNUP"), "DLEN CHILL||SIGNUP"
	end
end