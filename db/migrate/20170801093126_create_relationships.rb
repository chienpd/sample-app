class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |table|
      table.integer :follower_id
      table.integer :followed_id

      table.timestamps
    end
    add_index_to_table
  end

  private

  def add_index_to_table
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
