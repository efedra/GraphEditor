class RenameAgainItDidntGoWell < ActiveRecord::Migration[6.0]
  def change
    rename_table :game_users, :gameusers
  end
end
