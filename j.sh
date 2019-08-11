#!/bin/bash

JEDITOR=${EDITOR:-vi} 

[[ ${1} == "help" ]] && { 
  cat <<END_OF_HELP
"j" - a command line journal tool ; files are stored in ~/.j 

  j - by itself, this opens an editor on a journal file named YYYY-MM/YYYY-MM-DD

      You can add whatever you like. No formatting required.  Uses \$EDITOR 
      if set; vi otherwise (your editor appears to be ${JEDITOR}

  j show - just cat's today's journal file 

  j showweek - cat out the last 5 days journal files

  j todo - opens an editor on ~/.j/todo. You can add whatever you want, 
      such as one line for each todo item on your list. But any other 
      formatting or text is fine.

      However, any lines that are prepended with "DONE" will be removed 
      after editing and appended to the file ~/.j/todo.done. In the todo.done
      file, the transferred "DONE" lines will have the date inserted.

      Typically, you'd 'j todo' and add some lines with things on your mind. 
      When you've finally gotten some things done, 'j todo' again and insert 
      "DONE" at the beginning of the line. No problem with just adding a 
      new "DONE" line from scratch.

      For readability of todo and done files, you may want to start each item
      with a project-name prefix; this helps in greping (see below)

      After any editing, the todo and todo.done files are committed to 
      the local repo (~/.j/.git) (not pushed anywhere; sorta relying on whatever
      proper backup process you have)

  j todo string - this will 'grep -i' the string on the todo file

  j done - shows tail on todo.done 

  j done string - does a grep -i of the string on todo.done 
END_OF_HELP

  exit
}

# if ever do multi-project, would figure out "new" path here...

# project setup if needed 
J_DIR=${JHOME:-${HOME}/.j}
mkdir -p ${J_DIR}
# we 'cd' so that git commands work nicely
if ! cd ${J_DIR} > /dev/null 2>&1 ; then 
  echo oops, couldn\'t get to journal directory ${J_DIR} 
  exit 1 
fi
pwd 

# more vars and setup; dirs and files are relative to the current directory: J_DIR
MJ_DIR=$(date +%Y-%m)
mkdir -p ${MJ_DIR}   # even if we don't need it
JFILE=${MJ_DIR}/$(date +%Y-%m-%d)
TODOFILE=todo
DONEFILE=todo.done
TMPFILE=todo.doneToFile
GMSG=$(date --iso-8601=seconds)

# final setup
[[ ! -d .git ]] && {
  echo git init
  git init
  touch ${TODOFILE} ${DONEFILE}
  git add ${TODOFILE} ${DONEFILE}
  git commit -m "init" ${TODOFILE} ${DONEFILE}
}

# now do the sub-commands ############

[[ ${1} == "todo" && ! -z "${2}" ]] && {
  grep -i "${2}" ${TODOFILE}
  exit
}

[[ ${1} == "todo" ]] && {  
  ${JEDITOR} ${TODOFILE}
  sed -n "s/^DONE /DONE $(date +%Y-%m-%d) /p" < ${TODOFILE} > ${TMPFILE}
  [[ ! -s ${TMPFILE} ]] && {
    echo nothing done
  } || {
    echo some things are done
    cat ${TMPFILE} >> ${DONEFILE}    # add DONE's (from above) to todo.done
    sed -i "/^DONE /d" ${TODOFILE}   # remove DONEs from todo, in-place
  }
  git commit -m "${GMSG}" ${TODOFILE} ${DONEFILE}
  exit
}

[[ ${1} == "done" ]] && {
  echo ${DONEFILE}
  [[ ! -z "${2}" ]] && {
    grep -i "${2}" ${DONEFILE}
  } || {
    tail -20 ${DONEFILE}
  }
  exit
}

[[ "${1}" == "showweek" ]] && {
  for d in 0 1 2 3 4 5
  do
    JFILE=$(date --date="$d day ago" +%Y-%m/%Y-%m-%d)
    [[ -s ${JFILE} ]] && {
      echo \# ${JFILE}
      cat ${JFILE}
      echo
    }
  done
  exit
}

[[ "${1}" == "show" ]] && {
  [[ -f ${JFILE} ]] && cat ${JFILE} || echo no jfile yet
  exit
}

# default, just edit the daily journal file
${JEDITOR} ${JFILE}
if ! git ls-files --error-unmatch ${JFILE} > /dev/null 2>&1 ; then
  git add ${JFILE}
fi
git commit -m "${GMSG}" ${JFILE}

exit
