352phish
========

A collection of scripts for a course project examining the possibility of generating phishing emails using data mined from social APIs

If you are going to run the script be sure to run the bundler's install function inside the source directory. Inside of src, run `bundle install` on your command line to install the necessary gems needed to execute the script.

To run the scripts, type `ruby main.rb` inside the src folder. These scripts are useless unless you specify an input template file to read from using the file option like so `ruby main.rb --file [filename]`. Also be aware you can gain some obnoxiously detailed insight into what is happening inside the scripts by setting the verbose option. EX: `ruby main.rb --verbose --file [filename]`.
