class ContextifyCreate < ActiveRecord::Migration
  create_table :permissions do |t|
    t.string   :object_type
    t.string   :action_name
    t.string   :description
    t.timestamps
  end

  create_table :permissions_roles do |t|
    t.integer :role_id
    t.integer :permission_id
  end

   create_table :contexts do |t|
    t.integer :user_id
    t.integer :role_id
    t.integer :entity_id
    t.string  :entity_type
  end

  add_index :contexts, [:user_id, :role_id]

  create_table :roles do |t|
    t.string   :name
    t.integer  :resource_id
    t.string   :resource_type
    t.timestamps
  end

  add_index :roles, [:name, :resource_type, :resource_id]
  add_index :roles, [:name]
end
