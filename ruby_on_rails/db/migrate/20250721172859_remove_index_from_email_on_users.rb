class RemoveIndexFromEmailOnUsers < ActiveRecord::Migration[7.2]
  def change
    remove_index :users, column: :email, name: 'index_users_on_email'
  end
end
