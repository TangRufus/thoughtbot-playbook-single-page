# encoding: utf-8
require 'nokogiri'

if !File.size?('home.html')
  `curl http://playbook.thoughtbot.com/ > home.html`
end
doc = Nokogiri::HTML.parse(File.open('home.html', 'r:utf-8'))

puts "Parsing table of contents"

toc = []
doc.css('nav a').each do |a|
  text = a.inner_text
  if a.parent.name == 'h2' 
    toc << {:section => text, :href => a[:href]}
  elsif a.parent.name == 'li'
    toc << {:page => text, :href => a[:href]}
  end
end

toc_doc = Nokogiri::HTML(File.read("home.html")).at("nav ul")
toc_doc.xpath('//@style').remove
toc_html = toc_doc.serialize.gsub(/ id=[^>]*/, '')

puts "Loading pages... This may take a while depending on your connection..."

big_html = toc.inject([toc_html]) do |memo, x|
  puts x[:href]
  html = `curl -sL 'http://playbook.thoughtbot.com#{x[:href]}'`
  doc = Nokogiri::HTML(html)
 
  memo << "<hr/><div><a name='#{x[:href].sub('/', '').gsub(/\W/, '_')}'></a></div>"
  memo << doc.at('section#content').inner_html
  memo
end

raw = big_html.join("\n")

File.open("raw.html", 'w') {|f| f.puts raw}

puts "Writing aggregated html fragments to raw.html"

raw = File.read("raw.html")

html = <<END
<!DOCTYPE html>
<html>
<head>
<title>Thoughtbot Playbook</title>
<meta charset="utf-8" />
<link rel="stylesheet" href="reset.css">
<link rel="stylesheet" href="style.css">
</head>
<body>
<div id="container">
#{ raw }
</div>
</body>
</html>
END

doc = Nokogiri::HTML(html)

print "Linking relative hrefs to anchors"

doc.search('a').each do |a|
  href = a[:href]
  if href =~ /^\//
    print '.'
    new = "<a href='##{href.gsub(/-/, '_').split('/').last}'>#{a.inner_text}</a>"
    a.swap(new)
  elsif href =~ /^./
  print '.'
  new = "<span>#{a.inner_text}</span>"
  a.swap(new)
  end
end
puts 
puts "Writing result out to playbook.html"
File.open("playbook.html", 'w') {|f| f.puts doc.serialize}

