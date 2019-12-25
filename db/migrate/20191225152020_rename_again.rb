class RenameAgain < ActiveRecord::Migration[6.0]
  class RenameGameUser < ActiveRecord::Migration[6.0]
    def change
      rename_table :game_users, :gameusers
    end
  end
end
#error while ctrl-C
# i dont want to touch it
# who knows what will happen
# someone does, but not me