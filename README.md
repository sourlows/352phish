352phish
========

A collection of scripts for a course project examining the possibility of generating phishing emails using data mined from social APIs. This was done as a proof of concept project for a university course.

Getting Started
-------
* [Download](https://github.com/sourlows/352phish/archive/master.zip) or [clone](https://github.com/sourlows/352phish.git) the source code.
* You will need a machine running Ruby 1.9.3+, in addition to [rubygems](https://rubygems.org/) and [bundler](https://rubygems.org/gems/bundler). These are already installed or can be installed on usask's tuxworld.
* Inside of the project's src folder, run `bundle install` on your command line to install the necessary gems needed to execute the script.
* You will need an authorization file to be able to authenticate with the APIs. Authentication files require usernames and passwords, so none is included with the source code. Please contact djw223@mail.usask.ca if you are the marker needing the authorization file. Let me know if you do not have github/facebook accounts and I may be able to provide necessary info, otherwise you will have to input your own.
* To run the scripts, type `ruby main.rb` inside the src folder and specify some options. 
  * The `--file [filename]` option specifies the input template file to use. `inputTest.txt` is provided with the source for testing the system.
  * The `--auth [filename]` options specifies the authorization file to use, which can be any plaintext file.
  * EX: `ruby main.rb --file inputTest.txt --auth myAuthFile`

Options: 
---------
`--verbose`: turn on verbose mode and print lots of information about what the script is doing behind the scenes. Not all of the output explains itself. 
`--file [filename]`: specify an input email template from which to parse/determine a query.  
`--auth [filename]`: specify a file with authorization information for each API used to authenticate with each API  

Input Template Format:
---------
Query terms are wrapped in square brackets. EX:
> Dear [name],
> [musician]'s new album is streaming at http://www.totallylegit.com. Be the first to here it and share on Facebook!
> Regards, The Totally Legit Team

In this case, the query sent to the APIs would require a public name (either first name or both names), and some musician they've associated themselves with on that social network, such as liking their page on Facebook. APIs that do not support all the query terms will not be queried, so input templates that are highly complex may not match up with a single API very well.

Queries also support url injection string transformation if needed. EX:
> Dear [name],
> [musician]'s new album is streaming at http://www.totallylegit.com/[_musician]. Be the first to here it and share on Facebook!
> Regards, The Totally Legit Team

In this case, we've taken the string associated with "musician" and removed all whitespace, special characters and downsized all uppercase letters so that it looks more like part of a valid url string. This can also be combined with things like PHP parameters to dynamically generate pages on your phishing site.

Authorization File Format:
-----------
The API name is on the first line, id is on the second line, and password/token is on the third line. EX:
> APIname  
> id: myUserName  
> secret: myPassword123  

Obviously authorization information for multiple APIs can be included in the same file. EX:
> Github  
> id: sourlows  
> secret: verySecretPassword  
> Facebook  
> id: myFBID  
> secret: myFBToken  
