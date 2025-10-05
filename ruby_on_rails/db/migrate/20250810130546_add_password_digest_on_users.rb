class AddPasswordDigestOnUsers < ActiveRecord::Migration[7.2]
  def up
    add_column :users, :password_digest, :string
    execute "UPDATE users SET password_digest = ''"
  end

  def down
    remove_column :users, :password_digest, :string
  end
end
