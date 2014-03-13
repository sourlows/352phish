352phish
========

A collection of scripts for a course project examining the possibility of generating phishing emails using data mined from social APIs

If you are going to run the script be sure to run the bundler's install function inside the source directory. Inside of src, run `bundle install` on your command line to install the necessary gems needed to execute the script.

To run the scripts, type `ruby main.rb` inside the src folder and specify some options. The `--file [filename]` and `--auth [filename]` options are probably required to run the scripts right now.

**Options:**  
`--verbose`: turn on verbose mode and print lots of information about what the script is doing behind the scenes.  
`--file [filename]`: specify an input email template from which to parse/determine a query.  
`--auth [filename]`: specify a file with authorization information for each API used to authenticate with each API  

**Input Template Format:**  
Query terms are wrapped in square brackets. EX:
> Dear [name],
> [musician]'s new album is streaming at http://www.totallylegit.com. Be the first to here it and share on Facebook!
> Regards, The Totally Legit Team

In this case, the query sent to the APIs would require a public email, a public name (either first name or both names), and some musician they've associated themselves with on that social network, such as liking their page on Facebook. APIs that do not support all the query terms will not be queried, so input templates that are highly complex may not match up with a single API very well.

**Authorization File Format:**  
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
