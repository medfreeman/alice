class AddUrlToYears < ActiveRecord::Migration
  def change
    # allow some years to point to custom urls, instead of rails
    # this is to handle the case of year 2017/2018, where some of the DB was lost
    # and we had to use static sites instead.
    add_column :years, :url, :string
  end
end
