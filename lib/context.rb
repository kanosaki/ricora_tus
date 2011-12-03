# Data loadfor site meta context

require 'yaml'

SITE_MENU_FILEPATH = File.join(File.dirname(__FILE__), "../sitedata/menu.yaml")
SITE_NEWS_FILEPATH = File.join(File.dirname(__FILE__), "../sitedata/news.yaml")

def sitemenu
  YAML.load_file(SITE_MENU_FILEPATH)
end

def sitenews
  YAML.load_file(SITE_NEWS_FILEPATH)
end

def next_meeting
  conf = @config[:next_meeting]
  if conf == "default"
    (Time.now + ((8 - Time.now.wday)%7)*60*60*24).strftime "%Y/%m/%d (%a)" + 
      " @ K306" # Next monday and default location
  else
    conf
  end
end

def vcs_logs
  format = "%s ||| by %an, %ad" 
  cmd = "git log -n5 --date=short --pretty=format:\"#{format}\""
  `#{cmd}`.split("\n").map{|s| s.split("|||") }
end
