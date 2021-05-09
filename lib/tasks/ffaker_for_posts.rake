require File.join(File.dirname(__FILE__), '../../config/environment')
namespace :fake do
  desc "faker posts data"
  task :posts do
    100.times do
      Post.create(
        title: FFaker::CheesyLingo.title,
        truncated_preview: FFaker::CheesyLingo.sentence
      )
    end
  end
end
