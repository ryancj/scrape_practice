require 'open-uri' #HTTP client
require 'open_uri_redirections'
require 'nokogiri' #Scraper
require 'json'
require 'pry-byebug'

url = 'http://www.cubecinema.com/programme' #Address
html = open(url, :allow_redirections => :safe) #Traverse

doc = Nokogiri::HTML(html) #Nokogiri instance
showings = [] #Store resuts

# <div class="showing" id="event_7557">
#   <a href="/programme/event/live-stand-up-monty-python-and-the-holy-grail,7557/">
#     <img src="/media/diary/thumbnails/montypython2_1.png.500x300_q85_background-%23FFFFFF_crop-smart.jpg" alt="Picture for event Live stand up + Monty Python and the Holy Grail">
#   </a>
#   <span class="tags"><a href="/programme/view/comedy/" class="tag_comedy">comedy</a> <a href="/programme/view/dvd/" class="tag_dvd">dvd</a> <a href="/programme/view/film/" class="tag_film">film</a> </span>
#   <h1>
#     <a href="/programme/event/live-stand-up-monty-python-and-the-holy-grail,7557/">
#       <span class="pre_title">Comedy Combo presents</span>
#       Live stand up + Monty Python and the Holy Grail
#       <span class="post_title">Rare screening from 35mm!</span>
#     </a>
#   </h1>
#   <div class="event_details">
#     <p class="start_and_pricing">
#       Sat 20 December | 19:30
#       <br>
#     </p>
#     <p class="copy">Brave (and not so brave) Knights of the Round Table! Gain shelter from the vicious chicken of Bristol as we gather to bear witness to this 100% factually accurate retelling ... [<a class="more" href="/programme/event/live-stand-up-monty-python-and-the-holy-grail,7557/">more...</a>]</p>
#   </div>
# </div>

doc.css('.showing').each do |showing|
  showing_id = showing['id'].split('_').last.to_i
  tags = showing.css('.tags a').map { |tag| tag.text.strip }
  title_el = showing.at_css('a h3')
  title_el.children.each { |c| c.remove if c.name == 'span' }
  title = title_el.text.strip
  dates = showing.at_css('.start_and_pricing').inner_html.strip
  dates = dates.split('<br>').map(&:strip).map { |d| DateTime.parse(d) }
  description = showing.at_css('.copy').text.gsub('[more...]', '').strip
  showings.push(
    id: showing_id,
    title: title,
    tags: tags,
    dates: dates,
    description: description
  )
end

puts JSON.pretty_generate(showings)
