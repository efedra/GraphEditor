class CreateImgs < ActiveRecord::Migration[6.0]
  def change
    create_table :imgs do |t|
      t.string :name
      t.text :pathtoimg
      t.text :commentaries
    end
  end
end
