class Link < ApplicationRecord
  GIST_URL = //

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: URI::regexp(%w[http https])

  def gist?
    url.match?(%r{https://gist.github.com/\w+/\w{32}})
  end
end
