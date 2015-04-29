class Link < ActiveRecord::Base
  attr_accessor :tweet, :url

  before_create :build_short_url

  belongs_to :user

  validates :long_url, presence: true
  validates :long_url, format: { with: URI.regexp }, if: Proc.new { |a| a.long_url.present? }

  def to_params
    short_url
  end

  def url
    long_url
  end

  private

    def build_short_url
      self.short_url = loop do
        random_url = rand(36**6).to_s(36)
        break random_url unless Link.exists?(short_url: random_url)
      end
    end
end
