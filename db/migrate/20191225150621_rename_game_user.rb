class RenameGameUser < ActiveRecord::Migration[6.0]
  def change
    rename_table :game_user, :game_users
  end
end
