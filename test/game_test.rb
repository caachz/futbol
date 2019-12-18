require 'minitest/pride'
require 'minitest/autorun'
require './lib/game'

class GameTest < Minitest::Test
  def setup
    @game = Game.from_csv('./data/dummy_game.csv')
  end

  def test_it_exists
    assert_instance_of Game, @game.first
  end

  def test_it_has_attributes
    assert_equal 2012030221, @game.first.game_id
    assert_equal 20122013, @game.first.season
    assert_equal "Postseason", @game.first.type
    assert_equal "5/16/13", @game.first.date_time
    assert_equal 3, @game.first.away_team_id
    assert_equal 6, @game.first.home_team_id
    assert_equal 2, @game.first.away_goals
    assert_equal 3, @game.first.home_goals
    assert_equal "Toyota Stadium", @game.first.venue
    assert_equal "/api/v1/venues/null", @game.first.venue_link
  end
end