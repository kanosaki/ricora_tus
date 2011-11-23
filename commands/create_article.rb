
usage       'deplpy'
aliases     :ca
summary     'Create blog page at /content/blog/'
description <<-EOS
EOS

required :t, :template, "Specity template name in template dir"

flag  :h, :help, 'Show help for this command' do |value, cmd|
  puts "Some help"
  exit 0
end

run do |opts, args, cmd|
  BlogCreator.call(opts, args, cmd)
end


PROJECT_ROOT = File.absolute_path(File.join(File.dirname(__FILE__), "../"))

require 'erubis'

class BlogCreator < Nanoc3::CLI::Command
  def run
    puts "Creating new blog post.."
    write_skelton(skelton)
    puts "Complete."
    puts "Blog post created at #{dst_path}"
  end

  def write_skelton(body)
    open(dst_path, 'w') do |f|
      f.write(body)
    end
  end

  def skelton
    engine = Erubis::Eruby.new(template)
    engine.evaluate(context)
  end

  def context
    @context ||= Erubis::Context.new(
      :title => title,
      :timestamp => article_timestamp)
  end

  def template
    File.read(template_path)
  end

  def template_path
    t_name = options[:template] || config[:default_skelton_name] || "default.erb"
    File.join(config[:skelton_dir], t_name)
  end

  def dst_path
    File.join(blog_dir, filename + ".html")
  end
  
  def filename
    "#{file_timeprefix}_#{escaped_title}"
  end

  def title
    extract_blogtitle(arguments)
  end
  
  def escaped_title
    title.gsub(" ", "-")
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

