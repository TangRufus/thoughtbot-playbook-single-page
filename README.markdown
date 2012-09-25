# Thoughtbot Playbook on One Page

This quick and dirty Ruby script pulls down the pages of Thoughtbot's Playbook
from <http://playbook.thoughtbot.com/> and generates a single-page HTML version
of the content.

Why? Because single-page is

* faster to navigate
* easier to search 
* easier to read offline
* easier to print out to read and annotate on paper
* easier to convert to other formats, like PDF or plain text (use elinks -dump)

To run:

      ruby playbook.rb

This will generate the playbook in file called `playbook.html`.

In case of `cannot load such file -- nokogiri (LoadError)` problems try:
		
      gem install nokogirl

You can see a version of the output here:

<http://danielchoi.com/software/thoughtbot-playbook.html>

Please fork and improve at will.

A huge thanks to THOUGHTBOT for sharing their accumulated wisdom. 

## Contributors

* Wyatt Greene <https://github.com/techiferous> pulled in the styling from Thoughtbot's original css

* Tang Rufus <https://github.com/TangRufus> added support to pull the HTML5 verion of Thoughtbot's Playbook