class EnableBtreeGinExtension < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'btree_gin'
  end
end
