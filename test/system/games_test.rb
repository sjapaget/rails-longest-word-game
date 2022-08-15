require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  # test "Going to /new gives us a new random grid to play with" do
  #   visit new_url
  #   assert test: "New game"
  #   assert_selector "li", count: 10
  # end

  test "Random word gets invalid word message" do
    visit new_url
    fill_in 'input', with: 'Help'
    click_on 'score'

    assert_text "Congratulations"
  end
end
