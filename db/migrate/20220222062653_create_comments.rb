class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.belongs_to :commentable, polymorphic: true, null: false
      t.belongs_to :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
