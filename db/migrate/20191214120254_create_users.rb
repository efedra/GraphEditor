class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      # id?
      t.string :name
      t.string :login
      t.string :password # ???

      t.timestamps

    end
    create_table :games do |t|
      t.string :title
      t.text :description

      t.timestamps

    end

    create_table :game_user do |t|
      t.integer :user_id
      t.integer :game_id

      t.timestamps
    end

    create_table :texts do |t|
      t.text :text_content
      t.text :commentaries
      t.integer :game_id

      t.timestamps

    end

  end
end
