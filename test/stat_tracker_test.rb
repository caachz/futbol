require_relative 'test_helper'
require_relative '../lib/stat_tracker'
require './lib/calculable'

class StatTrackerTest < Minitest::Test
  include Calculable

  def setup
    @stat_tracker = StatTracker.from_csv({games: './data/dummy_game.csv', teams: './data/dummy_team.csv', game_teams: './data/dummy_game_team.csv'})
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_it_has_attributes
    assert_equal './data/dummy_game.csv', @stat_tracker.game_path
    assert_equal './data/dummy_team.csv', @stat_tracker.team_path
    assert_equal './data/dummy_game_team.csv', @stat_tracker.game_teams_path
  end

  def test_it_creates_an_array_of_all_objects
    assert_instance_of Array, @stat_tracker.game_teams
    assert_instance_of GameTeam, @stat_tracker.game_teams[0]
    assert_instance_of Array, @stat_tracker.games
    assert_instance_of Game, @stat_tracker.games[0]
    assert_instance_of Array, @stat_tracker.teams
    assert_instance_of Team, @stat_tracker.teams[0]
  end

  def test_it_can_find_highest_total_score
    assert_equal 501, @stat_tracker.highest_total_score
  end

  def test_it_can_find_lowest_total_score
    assert_equal 0, @stat_tracker.lowest_total_score
  end

  def test_it_can_find_average_goals_per_game
    assert_equal 16.28, @stat_tracker.average_goals_per_game
  end

  def test_it_can_find_percentage_home_wins
    assert_equal 0.56, @stat_tracker.percentage_home_wins
  end

  def test_it_can_find_percentage_ties
    assert_equal 0.13, @stat_tracker.percentage_ties
  end

  def test_it_can_count_the_number_of_games_in_a_season
    assert_equal ({"20122013"=>27, "20142015"=>6, "20162017"=>4, "20152016"=>2, "20132014"=>1}), @stat_tracker.count_of_games_by_season
  end

  def test_it_can_find_average_goals_by_season
    assert_equal ({"20122013"=>27, "20142015"=>6, "20162017"=>4, "20152016"=>2, "20132014"=>1}), @stat_tracker.count_of_games_by_season
  end

  def test_it_can_find_count_of_teams
    assert_equal 16, Team.count_of_teams
  end

  def test_it_can_pull_all_teams_with_the_worst_fans
    stat_tracker = StatTracker.from_csv({games: './data/game.csv', teams: './data/team.csv', game_teams: './data/game_team.csv'})
    assert_equal ["Houston Dynamo", "Utah Royals FC"], stat_tracker.worst_fans
    assert_equal ["Los Angeles FC", "LA Galaxy", "Atlanta United", "DC United"], @stat_tracker.worst_fans
  end

  def test_it_can_pull_teams_with_the_best_fans
    stat_tracker = StatTracker.from_csv({games: './data/dummy_game.csv', teams: './data/dummy_team.csv', game_teams: './data/dummy_game_team.csv'})

    assert_equal "Orlando City SC", stat_tracker.best_fans
  end

  def test_team_with_best_offense
    assert_equal "Real Salt Lake", @stat_tracker.best_offense
  end

  def test_team_with_worst_offense
    stat_tracker = StatTracker.from_csv({games: './data/game.csv', teams: './data/team.csv', game_teams: './data/game_team.csv'})

    assert_equal "Utah Royals FC", stat_tracker.worst_offense
  end

  def test_highest_scoring_home_team
    stat_tracker = StatTracker.from_csv({games: './data/game.csv', teams: './data/team.csv', game_teams: './data/game_team.csv'})

    assert_equal "Reign FC", stat_tracker.highest_scoring_home_team
  end

  def test_lowest_scoring_home_team
    stat_tracker = StatTracker.from_csv({games: './data/game.csv', teams: './data/team.csv', game_teams: './data/game_team.csv'})

    assert_equal "Utah Royals FC", stat_tracker.lowest_scoring_home_team
  end

  def test_lowest_scoring_visitor
    stat_tracker = StatTracker.from_csv({games: './data/game.csv', teams: './data/team.csv', game_teams: './data/game_team.csv'})

    assert_equal "San Jose Earthquakes", stat_tracker.lowest_scoring_visitor
  end

  def test_winningest_team
    assert_equal "Toronto FC", @stat_tracker.winningest_team
  end

  def test_highest_scoring_visitor
    stat_tracker = StatTracker.from_csv({games: './data/game.csv', teams: './data/team.csv', game_teams: './data/game_team.csv'})

    assert_equal "FC Dallas", stat_tracker.highest_scoring_visitor
  end

  def test_worst_defense
    assert_equal "Sporting Kansas City", @stat_tracker.worst_defense
  end

  def test_best_defense
    assert_equal "FC Dallas", @stat_tracker.best_defense
  end

  def test_least_accurate_team
    assert_equal "Seattle Sounders FC", @stat_tracker.least_accurate_team("20122013")
  end

  def test_most_accurate_team
    assert_equal "Los Angeles FC", @stat_tracker.most_accurate_team("20122013")
  end

  def test_most_tackles
    assert_equal "FC Dallas", @stat_tracker.most_tackles("20122013")
  end

  def test_fewest_tackles
    assert_equal "DC United", @stat_tracker.fewest_tackles("20122013")
  end

  def test_most_goals_scored
    assert_equal 4, @stat_tracker.most_goals_scored("6")
  end

  def test_fewest_goals_scored
    assert_equal 0, @stat_tracker.fewest_goals_scored("2")
  end

  def test_winningest_coach
    assert_equal "Peter Laviolette", @stat_tracker.winningest_coach("20122013")
  end

  def test_worst_coach
    assert_equal "Todd McLellan", @stat_tracker.worst_coach("20122013")
  end

  def test_biggest_bust
    assert_equal "Houston Dynamo", @stat_tracker.biggest_bust("20132014")
  end

  def test_biggest_surprise
    assert_equal "New England Revolution", @stat_tracker.biggest_surprise("20142015")
  end

  def test_average_win_percentage
    assert_equal 0.73, @stat_tracker.average_win_percentage("16")
  end


  def test_worst_loss
    stat_tracker = StatTracker.from_csv({games: './data/game.csv', teams: './data/team.csv', game_teams: './data/game_team.csv'})

    assert_equal 5, stat_tracker.worst_loss("6")
  end

  def test_biggest_team_blowout
    stat_tracker = StatTracker.from_csv({games: './data/game.csv', teams: './data/team.csv', game_teams: './data/game_team.csv'})

    assert_equal 6, stat_tracker.biggest_team_blowout("24")
  end

  def test_best_season
    assert_equal "20142015", @stat_tracker.best_season("16")
  end

  def test_worst_season
    assert_equal "20122013", @stat_tracker.worst_season("16")
  end

  def test_head_to_head
    expected = {"LA Galaxy"=>0.5, "DC United"=>0.8, "Orlando City SC"=>0.67}
    assert_equal expected, @stat_tracker.head_to_head("16")
  end

  def test_rival
    assert_equal "LA Galaxy", @stat_tracker.rival("16")
  end

  def test_favorite_opponent
    assert_equal "DC United", @stat_tracker.favorite_opponent("16")
  end

  def test_seasonal_summary
    expected = {"20122013"=>{:regular_season=>{:win_percentage=>0.0, :total_goals_scored=>2,
                :total_goals_against=>2, :average_goals_scored=>2.0, :average_goals_against=>2.0},
                :postseason=>{:win_percentage=>0.75, :total_goals_scored=>8, :total_goals_against=>6,
                :average_goals_scored=>2.0, :average_goals_against=>1.5}},
                "20142015"=>{:regular_season=>{:win_percentage=>0.0, :total_goals_scored=>0,
                :total_goals_against=>0, :average_goals_scored=>0.0, :average_goals_against=>0.0},
                :postseason=>{:win_percentage=>0.8, :total_goals_scored=>11, :total_goals_against=>8,
                :average_goals_scored=>2.2, :average_goals_against=>1.6}}}
    assert_equal expected, @stat_tracker.seasonal_summary("16")
  end

  def test_teamnameable
    assert_equal "FC Dallas", @stat_tracker.id_to_teamname(6, @stat_tracker.teams)
  end

  def test_biggest_blowout
    assert_equal 499, @stat_tracker.biggest_blowout
  end

  def test_percentage_visitor_wins
    assert_equal 0.34, @stat_tracker.percentage_visitor_wins
  end

  def test_average_goals_by_season
    result = {"20122013"=>22.04, "20142015"=>4.0, "20162017"=>4.75, "20152016"=>4.0, "20132014"=>5.0}
    assert_equal result, @stat_tracker.average_goals_by_season
  end

  def test_count_of_teams
    assert_equal 16, @stat_tracker.count_of_teams
  end

  def test_team_info
    result = {"team_id"=>"24", "franchise_id"=>"32", "team_name"=>"Real Salt Lake", "abbreviation"=>"RSL", "link"=>"/api/v1/teams/24"}
    assert_equal result, @stat_tracker.team_info("24")
  end

  def test_accurate_team_calculation
    result = {24=>{:goals=>7, :attempts=>21}, 28=>{:goals=>2, :attempts=>4}, 16=>{:goals=>10, :attempts=>44}, 30=>{:goals=>5, :attempts=>19}, 19=>{:goals=>5, :attempts=>19}, 17=>{:goals=>10, :attempts=>32}, 2=>{:goals=>2, :attempts=>21}, 1=>{:goals=>5, :attempts=>12}, 14=>{:goals=>2, :attempts=>4}, 4=>{:goals=>3, :attempts=>8}, 15=>{:goals=>6, :attempts=>23}, 5=>{:goals=>8, :attempts=>46}, 3=>{:goals=>9, :attempts=>53}, 26=>{:goals=>2, :attempts=>12}, 6=>{:goals=>24, :attempts=>76}}

    assert_equal result, GameteamGameTeamAggregable.accurate_team_calculation("20122013", @stat_tracker.game_teams, @stat_tracker.games, @stat_tracker.teams)
  end

  def test_game_teams_postseason
    assert_instance_of Array, GameteamGameTeamAggregable.game_teams_postseason("20122013", @stat_tracker.game_teams, @stat_tracker.games, @stat_tracker.teams)
  end

  def test_game_teams_regular_season
    assert_instance_of Array, GameteamGameTeamAggregable.game_teams_regular_season("20122013", @stat_tracker.game_teams, @stat_tracker.games, @stat_tracker.teams)
  end

  def test_postseason_games_per_team
    assert_equal ({5=>6, 2=>2, 3=>7, 15=>2, 30=>2, 16=>4, 24=>2, 17=>4, 19=>2, 26=>2, 6=>9}), GameteamGameTeamAggregable.postseason_games_per_team("20122013", @stat_tracker.game_teams, @stat_tracker.games, @stat_tracker.teams)
  end

  def test_postseason_team_wins
    assert_equal ({5=>2, 15=>2, 16=>3, 24=>1, 17=>2, 19=>1, 26=>1, 6=>9}), GameteamGameTeamAggregable.postseason_team_wins("20122013", @stat_tracker.game_teams, @stat_tracker.games, @stat_tracker.teams)
  end

  def test_postseason_win_percentage
    assert_equal ({5=>0.3333333333333333, 2=>2, 3=>7, 15=>1.0, 30=>2, 16=>0.75, 24=>0.5, 17=>0.5, 19=>0.5, 26=>0.5, 6=>1.0}), GameteamGameTeamAggregable.postseason_win_percentage("20122013", @stat_tracker.game_teams, @stat_tracker.games, @stat_tracker.teams)
  end

  def test_regular_season_games_per_team
    assert_equal ({24=>1, 28=>1, 16=>1, 30=>1, 19=>1, 17=>1, 2=>1, 1=>2, 14=>1, 4=>1, 15=>1}), GameteamGameTeamAggregable.regular_season_games_per_team("20122013", @stat_tracker.game_teams, @stat_tracker.games, @stat_tracker.teams)
  end

  def test_regular_season_team_wins
    assert_equal ({1=>1, 4=>1}), GameteamGameTeamAggregable.regular_season_team_wins("20122013", @stat_tracker.game_teams, @stat_tracker.games, @stat_tracker.teams)
  end

  def test_regular_season_win_percentage
    assert_equal ({24=>1, 28=>1, 16=>1, 30=>1, 19=>1, 17=>1, 2=>1, 1=>0.5, 14=>1, 4=>1.0, 15=>1}), GameteamGameTeamAggregable.regular_season_win_percentage("20122013", @stat_tracker.game_teams, @stat_tracker.games, @stat_tracker.teams)
  end

  def test_difference
    assert_equal ({24=>-0.5, 28=>1, 16=>-0.25, 30=>1, 19=>-0.5, 17=>-0.5, 2=>1, 1=>0.5, 14=>1, 4=>1.0, 15=>0.0, 5=>0.3333333333333333, 3=>7, 26=>0.5, 6=>1.0}), GameteamGameTeamAggregable.difference("20122013", @stat_tracker.game_teams, @stat_tracker.games, @stat_tracker.teams)
  end

  def test_total_games_per_team
    assert_equal ({24=>7, 28=>3, 16=>11, 30=>3, 19=>3, 17=>5, 2=>3, 1=>3, 14=>7, 4=>2, 15=>3, 5=>6, 3=>9, 26=>4, 6=>9, 20=>4}), GameteamTeamAggregable.total_games_per_team(@stat_tracker.game_teams, @stat_tracker.teams)
  end

  def test_total_team_wins
    assert_equal ({24=>7, 28=>3, 16=>11, 30=>3, 19=>3, 17=>5, 2=>3, 1=>3, 14=>7, 4=>2, 15=>3, 5=>6, 3=>9, 26=>4, 6=>9, 20=>4}), GameteamTeamAggregable.total_games_per_team(@stat_tracker.game_teams, @stat_tracker.teams)
  end

  def test_team_win_percentage
    assert_equal ({24=>7, 28=>3, 16=>11, 30=>3, 19=>3, 17=>5, 2=>3, 1=>3, 14=>7, 4=>2, 15=>3, 5=>6, 3=>9, 26=>4, 6=>9, 20=>4}), GameteamTeamAggregable.total_games_per_team(@stat_tracker.game_teams, @stat_tracker.teams)
  end

  def test_relavent_games
    assert_instance_of Array, GameTeamAggregable.relavent_games("6", @stat_tracker.games, @stat_tracker.teams)
  end

  def test_oppo_hash
    assert_instance_of Hash, GameTeamAggregable.oppo_hash("6", @stat_tracker.games, @stat_tracker.teams)
  end

  def test_teams_counter_hash_for_accuracy_methods
    game_ids = [2012030221, 2012030222, 2012030223, 2012030224]
    result = {3=>{:goals=>0, :attempts=>0}, 6=>{:goals=>0, :attempts=>0}}
    assert_equal result, GameteamGameTeamAggregable.teams_counter_hash_for_accuracy_methods(@stat_tracker.game_teams, game_ids)
  end

  def test_accuracy_incrementer
    teams_counter = {3=>{:goals=>0, :attempts=>0}, 6=>{:goals=>0, :attempts=>0}}
    game_ids = [2012030221, 2012030222, 2012030223, 2012030224]
    result = {3=>{:goals=>0, :attempts=>0}, 6=>{:goals=>0, :attempts=>0}}
    assert_equal 2012020087, GameteamGameTeamAggregable.accuracy_incrementer(@stat_tracker.game_teams, game_ids, teams_counter)[0].game_id
  end

  def test_lowest_scoring_incrementing
    all_teams = game_team_ids_games_and_goals(@stat_tracker.game_teams)
    assert_equal 2012020087, GameteamTeamAggregable.lowest_scoring_incrementing(@stat_tracker.game_teams, all_teams)[0].game_id
  end

  def test_highest_scoring_incrementing
    team_goals = game_team_ids_games_and_goals(@stat_tracker.game_teams)
      assert_equal 2012020087, GameteamTeamAggregable.highest_scoring_incrementing(@stat_tracker.game_teams, team_goals)[0].game_id
  end

  def test_defense_accumulator
    result = {6=>{:games=>0, :goals_allowed=>0}, 3=>{:games=>0, :goals_allowed=>0}, 5=>{:games=>0, :goals_allowed=>0}, 16=>{:games=>0, :goals_allowed=>0}, 17=>{:games=>0, :goals_allowed=>0}, 14=>{:games=>0, :goals_allowed=>0}, 24=>{:games=>0, :goals_allowed=>0}, 20=>{:games=>0, :goals_allowed=>0}, 2=>{:games=>0, :goals_allowed=>0}, 1=>{:games=>0, :goals_allowed=>0}, 4=>{:games=>0,:goals_allowed=>0}, 15=>{:games=>0, :goals_allowed=>0}, 19=>{:games=>0, :goals_allowed=>0}, 26=>{:games=>0, :goals_allowed=>0}, 28=>{:games=>0, :goals_allowed=>0}, 30=>{:games=>0, :goals_allowed=>0}}
    assert_equal result, GameTeamAggregable.defense_accumulator(@stat_tracker.games)
  end

  def test_season_collector
    result = {"20122013"=>{:game_ids=>[2012030221, 2012030222, 2012030223, 2012030224, 2012030225, 2012030311, 2012030312, 2012030313, 2012030314, 2012030231, 2012020122, 2012020521, 2012030182, 2012020087, 2012030151, 2012020142, 2012030183, 2012020104, 2012030111, 2012020089, 2012030131,2012030232, 2012030162, 2012030112, 2012030132, 2012030152, 2012030161], :wins=>0, :games=>0}, "20142015"=>{:game_ids=>[2014030411, 2014030412, 2014030413, 2014030414, 2014030415, 2014020348], :wins=>0, :games=>0}, "20162017"=>{:game_ids=>[2016030171, 2016030172, 2016030173, 2016030174], :wins=>0, :games=>0}, "20152016"=>{:game_ids=>[2015030181, 2015030182], :wins=>0, :games=>0}, "20132014"=>{:game_ids=>[2013020444], :wins=>0, :games=>0}}

    assert_equal result, GameteamGameAggregable.season_collector(@stat_tracker.games)
  end

  def test_game_id_tackles
    assert_equal [2012030221, 2012030222, 2012030223, 2012030224, 2012030225, 2012030311, 2012030312, 2012030313, 2012030314, 2012030231, 2012020122, 2012020521, 2012030182, 2012020087, 2012030151, 2012020142, 2012030183, 2012020104, 2012030111, 2012020089, 2012030131, 2012030232, 2012030162, 2012030112, 2012030132, 2012030152, 2012030161], GameteamGameTeamAggregable.game_id_tackles("20122013", @stat_tracker.game_teams, @stat_tracker.games, @stat_tracker.teams)
  end
end
