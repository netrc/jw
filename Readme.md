

# jw - a little journal/todo command line tool

"jw" is a node script to automate some journaling and
todo lists from the command line; data is stored in Firebase.

"j.sh" is the MVP bash shell script version; files are stored 
locally and committed to local repo (only).

## Usage

*jw* - by itself, this opens an editor on a journal file named YYYY-MM/YYYY-MM-DD

You can add whatever you like. No formatting required. Track contacts, meetings, whatever. Uses \$EDITOR 
if set; vi otherwise.

*j show [n]* - just cat's today's file. With an integer N, show the past N day's journal files.

*j todo* - opens an editor on ~.j/todo. You can add whatever you want, 
such as one line for each todo item on your list. But any other 
formatting or text is fine.

However, any lines that are prepended with "DONE " will be removed 
after editing and appended to the file ~/./todo.done. (Note: that is "DONE\<space\>")
In the todo.done file, the transferred "DONE " lines will have the date inserted.

Typically, you'd 'j todo' and add some lines with things on your mind. 
When you've finally gotten some things done, 'j todo' again and insert 
"DONE " at the beginning of the line. No problem with just adding a 
new "DONE " line from scratch.

For readability of todo and done files, you may want to start each item
with a project-name prefix; this helps in greping (see below)

After any editing, the todo and todo.done files are committed to 
the local repo (~/.j/.git) (not pushed anywhere)

*j todo string* - this will 'grep -i' the string on the todo file

*j done* - shows tail -20 on todo.done 

*j done string* - does a grep -i of the string on todo.done 

## Files

for j.sh, files are stored in ~/.j  or ${JHOME}/.j; *~/.j/todo*  - your todo list; 
*~/.j/todo.done*  - your list of done items (auto-created when "^DONE " is prepended)
*~/.j/2019-08/2019-08-07*  - your set of daily journal files

## TODO  :-)

* actual cli j todo:add foo bar baz
* actual cli j :add  foo bar baz (to journal)
* want to make this quieter
* trap 'rm .toDone' EXIT ??
* ability to set diff project dirs (why? multi-user?)  j new px /some/path (stored in .j/config);  j px ? syntax 
* add -d option for debugging



# New ??

j - manages todos and projects
* todo (gist)
* and local files
* journal/done (gist)
* dashboard (trello)

// which is kinda crazy

j   // list todo projects in gist
j <proj>   // list todo for proj
j <proj> ......   // add todo item to project
j -list    // list projects in todo jist
j -vi <proj>   // list todo into file; edit file; put file back in gist; "DONE" items go to done gist
j -done <proj>   // list done items for project
j -done <proj> ......   // add timestamp, DONE text to done gist
j dash    // list projects  ?? backlog??
j dash <proj>  // show card for project
j dash -next <proj> ......   // make next text
j dash -emoji <proj> x   // set emoji
j dash -prog <proj> NN    // set progress %

