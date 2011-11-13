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
