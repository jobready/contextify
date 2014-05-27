module Contextify::Role
  def self.names
    scoped.map(&:name)
  end
end