# frozen_string_literal: true

class ModifyReferneceToBeUnique < ActiveRecord::Migration[7.0]
  def change
    add_index :merchants, :reference, unique: true
  end
end
