def stub_tweet
  ret = File.open("#{Rails.root}/spec/support/tweet_return.json")
  stub_request(:post, /api.twitter.com/).
    to_return(status:200, body: ret)
end
