class Createjoke < ActiveRecord::Migration[6.0]
  def change
    create_table :jokes do |column|
      column.string :joke
      column.string :joke_id
      column.index :messages
    end
  end
end
