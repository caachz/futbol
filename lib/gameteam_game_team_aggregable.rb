require_relative 'calculable'

module GameteamGameTeamAggregable
  extend Calculable

  def self.accurate_team_calculation(season_id, game_teams, games, teams)
    game_ids = []
    games.each do |game|
      if game.season == season_id
        game_ids << game.game_id
      end
    end
    teams_counter = game_teams.reduce({}) do |acc, game_team|
      if game_ids.include?(game_team.game_id)
        acc[game_team.team_id] = {goals: 0, attempts: 0}
      end
      acc
    end
    game_teams.each do |game_team|
      if game_ids.include?(game_team.game_id)
        teams_counter[game_team.team_id][:goals] += game_team.goals
        teams_counter[game_team.team_id][:attempts] += game_team.shots
      end
    end
    teams_counter
  end

  def self.least_accurate_team(season_id, game_teams, games, teams)
    teams_counter = accurate_team_calculation(season_id, game_teams, games, teams)
    final = teams_counter.max_by do |key, value|
      value[:attempts].to_f / value[:goals]
    end[0]
    (teams.find { |team| final == team.team_id }).teamname
  end

  def self.most_accurate_team(season_id, game_teams, games, teams)
     teams_counter = accurate_team_calculation(season_id, game_teams, games, teams)

     final = teams_counter.min_by do |key, value|
       value[:attempts].to_f / value[:goals]
     end[0]

     teams.find do |team|
       final == team.team_id
     end.teamname
  end

  def self.most_tackles(season_id, game_teams, games, teams)
    game_ids = []
    games.find_all do |game|
      if game.season == season_id
        game_ids << game.game_id
      end
    end
    all_teams = game_teams.reduce({}) do |acc, game_team|
      acc[game_team.team_id] = {total_tackles: 0}
      acc
    end
    game_teams.each do |game_team|
      if game_ids.include?(game_team.game_id)
    all_teams[game_team.team_id][:total_tackles] += game_team.tackles
      end
    end
    team_with_most_tackles = all_teams.max_by do |team|
      team.last[:total_tackles]
    end
    (teams.find {|team| team.team_id == team_with_most_tackles.first}).teamname
  end

  def self.fewest_tackles(season_id, game_teams, games, teams)
    game_ids = []
    games.find_all do |game|
      if game.season == season_id
        game_ids << game.game_id
      end
    end
    all_teams = game_teams.reduce({}) do |acc, game_team|
      if game_ids.include?(game_team.game_id)
        acc[game_team.team_id] = {total_tackles: 0}
      end
      acc
    end
    game_teams.each do |game_team|
      if all_teams[game_team.team_id] && game_ids.include?(game_team.game_id)
        all_teams[game_team.team_id][:total_tackles] += game_team.tackles
      end
    end
    team_with_least_tackles = all_teams.min_by do |team|
      team.last[:total_tackles]
    end
    (teams.find {|team| team.team_id == team_with_least_tackles.first}).teamname
  end

  def self.game_teams_postseason(season_type, game_teams, games, teams)
    postseason = games.find_all { |game| game.type == "Postseason" && game.season == season_type }
    postseason_ids = postseason.map { |game| game.game_id }
    game_teams.find_all { |game_team| postseason_ids.include?(game_team.game_id) }
  end

  def self.game_teams_regular_season(season_type, game_teams, games, teams)
    regular_season = games.find_all { |game| game.type == "Regular Season" && game.season == season_type}
    regular_season_ids = regular_season.map { |game| game.game_id }
    game_teams.find_all { |game_team| regular_season_ids.include?(game_team.game_id) }
  end

  def self.biggest_bust(season_type, game_teams, games, teams)
    postseason_games_per_team = game_teams_postseason(season_type, game_teams, games, teams).reduce(Hash.new(0)) do |acc, game_team|
      acc[game_team.team_id] +=1
      acc
    end
    postseason_team_wins = game_teams_postseason(season_type, game_teams, games, teams).reduce(Hash.new(0)) do |acc, game_team|
      acc[game_team.team_id] += 1 if game_team.result == "WIN"
      acc
    end
    postseason_win_percentage = postseason_games_per_team.merge(postseason_team_wins) do |game_team, games, wins|
      (wins.to_f/games)
    end
    regular_season_games_per_team = game_teams_regular_season(season_type, game_teams, games, teams).reduce(Hash.new(0)) do |acc, game_team|
      acc[game_team.team_id] +=1
      acc
    end
    regular_season_team_wins = game_teams_regular_season(season_type, game_teams, games, teams).reduce(Hash.new(0)) do |acc, game_team|
      acc[game_team.team_id] += 1 if game_team.result == "WIN"
      acc
    end
    regular_season_win_percentage = regular_season_games_per_team.merge(regular_season_team_wins) do |game_team, games, wins|
      (wins.to_f/games)
    end
    difference = regular_season_win_percentage.merge(postseason_win_percentage) do |game_team, regular_percentage, post_percentage|
      post_percentage - regular_percentage
    end
    postseason_teams_only = difference.find_all do |team|
      postseason_team_wins.keys.include?(team.first)
    end
    team_with_biggest_bust = difference.max_by { |team| team.last }
    (teams.find {|team| team.team_id == team_with_biggest_bust.first}).teamname
  end

  def self.biggest_surprise(season_type, game_teams, games, teams)
    postseason_games_per_team = game_teams_postseason(season_type, game_teams, games, teams).reduce(Hash.new(0)) do |acc, game_team|
      acc[game_team.team_id] +=1
      acc
    end
    postseason_team_wins = game_teams_postseason(season_type, game_teams, games, teams).reduce(Hash.new(0)) do |acc, game_team|
      acc[game_team.team_id] += 1 if game_team.result == "WIN"
      acc
    end
    postseason_win_percentage = postseason_games_per_team.merge(postseason_team_wins) do |game_team, games, wins|
      (wins.to_f/games)
    end
    regular_season_games_per_team = game_teams_regular_season(season_type, game_teams, games, teams).reduce(Hash.new(0)) do |acc, game_team|
      acc[game_team.team_id] +=1
      acc
    end
    regular_season_team_wins = game_teams_regular_season(season_type, game_teams, games, teams).reduce(Hash.new(0)) do |acc, game_team|
      acc[game_team.team_id] += 1 if game_team.result == "WIN"
      acc
    end
    regular_season_win_percentage = regular_season_games_per_team.merge(regular_season_team_wins) do |game_team, games, wins|
      (wins.to_f/games)
    end
    difference = regular_season_win_percentage.merge(postseason_win_percentage) do |game_team, regular_percentage, post_percentage|
      post_percentage - regular_percentage
    end
    postseason_teams_only = difference.find_all do |team|
      postseason_team_wins.keys.include?(team.first)
    end
    team_biggest_surprise = postseason_teams_only.max_by {|team| team.last}
    (teams.find {|team| team.team_id == team_biggest_surprise.first}).teamname
  end
end