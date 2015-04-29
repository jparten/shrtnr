class AddApiKeyToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :api_key, :string

    User.all.find_each do |user|
      user.generate_api_key
      user.save
    end
  end

  def self.down
    remove_column :users, :api_key
  end
end
