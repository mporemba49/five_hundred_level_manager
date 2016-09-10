class Team < ApplicationRecord
  default_scope { order(:league, :name) }

  def to_s
    name
  end

  def id_string
    id.to_s.rjust(4,'0')
  end
end
