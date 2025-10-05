class AddTokenOnUsers < ActiveRecord::Migration[7.2]
  def up
    add_column :users, :token, :string
    add_index :users, :token, unique: true
    execute <<-SQL
      UPDATE users
      SET token = md5(random()::text)
      WHERE token IS NULL;
    SQL
  end

  def down
    remove_column :users, :token, :string
  end
end
