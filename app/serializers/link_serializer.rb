class LinkSerializer < ActiveModel::Serializer
  attributes :id, :name, :url, :updated_at, :created_at
end
