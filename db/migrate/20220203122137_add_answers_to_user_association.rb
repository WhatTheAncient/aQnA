class AddAnswersToUserAssociation < ActiveRecord::Migration[6.0]
  def change
    change_table :answers do |t|
      t.belongs_to :user
    end
  end
end
