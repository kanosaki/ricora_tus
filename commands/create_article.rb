usage       'deplpy'
aliases     :ca
summary     'Create blog page at /content/blog/'
description 'Homuhomu'

flag  :h, :help, 'Show help for this command' do |value, cmd|
  puts "Some help"
  exit 0
end


run do |opts, args, cmd|
  BlogCreator.call(opts, args, cmd)
end

PROJECT_ROOT = File.absolute_path(File.join(File.dirname(__FILE__), "../"))
require 'erubis'
require 'pp'

SKELTON = <<-EOS
---
title: %s
created_at: %s
kind: article
tags: [enter, tags, here]
publish: true
---

Write article body here.
EOS

class BlogCreator < Nanoc3::CLI::Command
  def run
    puts "Creating new blog post.."
    skelton = article_skelton
    write_skelton(skelton)
    puts "Complete."
    puts "Blog post created at #{dst_path}"
  end

  def write_skelton(body)
    open(dst_path, 'w') do |f|
      f.write(body)
    end
  end

  def article_skelton
    sprintf(SKELTON, title, article_timestamp)
  end

  def dst_path
    File.join(blog_dir, filename + ".html")
  end
  
  def filename
    "#{file_timeprefix}_#{title_escaped}"
  end

  def title
    extract_blogtitle(arguments)
  end
  
  def title_escaped
    title.gsub(" ", "-")
  end

  def template_path
    config[:article_skelton] 
  end

  def timestamp
    @article_time ||= Time.now
  end
  
  def article_timestamp
    timestamp.strftime "%Y/%m/%d %H:%M:%S"
  end

  def file_timeprefix
    timestamp.strftime "%Y%m%d-%H%M%S"
  end
  
  def config
    site.config[:blog]
  end
  
  def blog_dir
    File.join(PROJECT_ROOT, config[:blog_dir])
  end

  def extract_blogtitle(args)
    if args.length < 1 
      puts "Blog title required."
      exit!
    end
    args.join(" ")
  end

end



