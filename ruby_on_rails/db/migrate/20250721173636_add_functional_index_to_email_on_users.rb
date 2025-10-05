class AddFunctionalIndexToEmailOnUsers < ActiveRecord::Migration[7.2]
  def up
    # add_index :users, 'lower(email)', name: 'functional_index_users_on_email', unique: true
    execute 'CREATE UNIQUE INDEX functional_index_users_on_email ON users (lower(email));'
  end

  def down
    execute 'DROP INDEX functional_index_users_on_email;'
  end
end
