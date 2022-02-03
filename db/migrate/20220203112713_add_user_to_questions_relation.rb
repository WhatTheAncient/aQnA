class AddUserToQuestionsRelation < ActiveRecord::Migration[6.0]
  def change
    change_table :questions do |t|
      t.belongs_to :user
    end
  end
end
