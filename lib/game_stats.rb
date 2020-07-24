require 'CSV'
require './lib/game'


class GameStats < Game
  attr_reader :games
  def initialize(filepath)
    @games = []
    load_games(filepath)
  end

  def load_games(filepath)
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |data|
      @games << Game.new(data)
    end
  end

  def find_by_id(game_id)
    @games.find do |game|
      game.game_id == game_id
    end
  end

  def highest_total_score
    @games.map do |game|
      (game.home_goals) + (game.away_goals)
    end.max
  end

  def lowest_total_score
    @games.map do |game|
      (game.home_goals) + (game.away_goals)
    end.min
  end

  def percentage_home_wins(id)
    home_games = @games.find_all do |game|
      game.home_team_id == id
    end
    home_games_wins = home_games.find_all do |game|
      game.home_goals > game.away_goals
    end
    ((home_games_wins.count.to_f / home_games.count.to_f) * 100).round(2)
  end


  def percentage_away_wins(id)
    away_games = @games.find_all do |game|
      game.away_team_id == id
    end
    away_games_wins = away_games.find_all do |game|
      game.away_goals > game.home_goals
    end
    ((away_games_wins.count.to_f / away_games.count.to_f) * 100).round(2)
  end

  def percentage_ties
    tied_games = @games.find_all do |game|
      game.home_goals == game.away_goals
    end
    ((tied_games.count.to_f / @games.count.to_f) * 100).round(2)
  end

    def games_by_season
     games_by_season = {} #
     season_by_id = games.group_by do |game|
       game.season
     end
     season_by_id.each do |season|
      games_by_season[season[0]] = season[1].count
     end
     games_by_season
    end

    def average_goals_per_game
      result = games.map do |game|
        game.total_goals_for_game
      end
      (result.sum.to_f / result.count.to_f).round(2)
    end

    def average_goals_for_season(season_games)
      goal_totals = []
      season_games.each do |game|
        goal_totals << game.total_goals_for_game
      end
      (goal_totals.sum.to_f / goal_totals.count.to_f).round(2)
    end

    def average_goals_by_season
     avg_goals_per_season = {}
     season_by_id = games.group_by do |game|
       game.season
     end
     season_by_id.each do |season, season_games|
       avg_goals_per_season[season] = average_goals_for_season(season_games)
     end
     avg_goals_per_season
    end

end
