class AddAttachments < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :avatar
    end
    change_table :pictures do |t|
      t.attachment :photo
    end
    change_table :tags do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :users, :avatar
    remove_attachment :pictures, :photo
    remove_attachment :tags, :photo
  end
end
