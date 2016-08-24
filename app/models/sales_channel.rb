class SalesChannel < ApplicationRecord
  default_scope { order(:name) }
end
