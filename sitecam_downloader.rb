require 'watir'
require 'stone'
require 'active_support/inflector'


def log_in(browser)
  browser.text_field(:id => 'edit-name').set '[USERNAME]'
  browser.text_field(:id => 'edit-pass').set '[PASSWORD]'
  browser.button(:name => 'op').click
end  

def get_all_session_links(browser)
   browser.links.collect {|link| link.href if link.href =~ /session\//}
end

def download_videos(browser, links)
  links.compact.each_with_index do |link, i|
    unless Video.first(:name => link)
      browser.goto link 
      browser.button(:id => 'edit-download-button').click
      save_video(link)
    end
  end
	
end

def save_video(name)
  video = Video.new
  video.name = name
  video.save  
end


#begin program
def main
  #start persistence layer
  Stone.start(Dir.pwd, Dir.glob(File.join(Dir.pwd,"/models/*")))
  
  #launch browser and go to sitecamsite
  browser = Watir::Browser.new :chrome
  browser.goto 'https://sitecamuser.com'
  log_in(browser)


  begin
    browser.goto 'https://sitecamuser.com/sessions/all'
     
    links = get_all_session_links(browser)

     download_videos(browser,links)
  ensure 
    browser.goto 'https://sitecamuser.com/logout'
  end
end


main()