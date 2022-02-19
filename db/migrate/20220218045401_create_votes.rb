class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :state
      t.belongs_to :user, foreign_key: true, null: false
      t.belongs_to :votable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
