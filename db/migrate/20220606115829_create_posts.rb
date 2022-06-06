class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :posts do |t|
      t.string :tags, array: true
      t.hstore :metadata

      t.timestamps
    end
  end
end
