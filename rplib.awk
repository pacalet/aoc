@include "debug"
@include "fifo"
@include "lifo"
@include "list"
@include "utils"

# Find first occurence in string `s` of any of the string values of indexed
# array `str`. `str` must be indexed from 1 to N where N is the number of
# strings to search for. If several strings are found, `how` selects which is
# retained: "first", "last", "firstshortest", "lastshortest", "firstlongest",
# "lastlongest".
function find_strings(s, str, how) {
	if(how !~ /^(first|last|firstshortest|lastshortest|firstlongest|lastlongest)$/) {
		debug::debug("ERROR: invalid find_strings how value (" how ")")
		exit(1)
	}
}

# Same a `index` but search for all occurences of string `t` in string `s`.
# Return the number of occurences. If array `a` is present it is first cleared
# and one entry is added per occurence, starting with index 1. Entry `a[n]` is
# the index of the `n`-th occurence of string `t` in `s`.
function aindex(s, t,    a) {
	delete a
	n=0
	i=1
	while(i<=length(s)) {
		tmp=index(substr(s, i), t)
		if(tmp) {
			i+=tmp
			a[++n]=i-1
		} else {
			return n
		}
	}
}

# Find matching character of an `open_char` / `close_char` pair in string
# `str`, starting at position `pos`. Return index of matching character or 0 if
# not found.
function find_matching(str, pos, open_char, close_char,    len, c, cnt, i) {
	if(length(open_char)!=1) {
		debug::debug("ERROR: find_matching: invalid opening character (" open_char ")\n")
		exit(1)
	}
	if(length(close_char)!=1) {
		debug::debug("ERROR: find_matching: invalid closing character (" close_char ")\n")
		exit(1)
	}
	len=length(str)
	if(pos>len || pos<1) {
		debug::debug("ERROR: invalid pos in find_matching (" pos ") with string of " len " characters\n")
		exit(1)
	}
	c=substr(str, pos, 1)
	if(c!=open_char && c!=close_char) {
		debug::debug("ERROR: invalid starting character in find_matching (" c ")\n")
		exit(1)
	}
	cnt=1
	if(c==open_char) {
		for(i=pos+1; i<=len; i++) {
			if(substr(str, i, 1)==open_char) {
			   cnt+=1
		   } else if(substr(str, i, 1)==close_char) {
			   cnt-=1
		   }
		   if(cnt==0) {
			   return i
		   }
	   }
   } else {
		for(i=pos-1; i>=1; i--) {
			if(substr(str, i, 1)==close_char) {
			   cnt+=1
		   } else if(substr(str, i, 1)==open_char) {
			   cnt-=1
		   }
		   if(cnt==0) {
			   return i
		   }
	   }
   }
   return 0
}

# Convert string `str` into a hierarchy of indexed arrays. `str` represents a
# list enclosed in a pair of `open_char` / `close_char` characters. List
# elements can be sub-lists or not, and are separated by character `sep_char`.
# They cannot contain characters `open_char`, `close_char`, or `sep_char`.
# Resulting arrays and sub-arrays are indexed from 0. Index 0 is the number N
# of elements, index 1 to N are the elements. Return 1 if `str` is a valid
# list, else 0.
function list_to_array(str, open_char, close_char, sep_char,    a, len, c, i) {
	delete a
	a[0]=0
	if(length(open_char)!=1) {
		debug::debug("ERROR: list_to_array: invalid opening character (" open_char ")\n")
		exit(1)
	}
	if(length(close_char)!=1) {
		debug::debug("ERROR: list_to_array: invalid closing character (" close_char ")\n")
		exit(1)
	}
	len=length(str)
	c=substr(str, 1, 1)
	if(c!=open_char) {
		debug::debug("ERROR: list_to_array: first character (" c ") is not the opening character (" open_char ")\n")
		exit(1)
	}
	c=substr(str, len, 1)
	if(c!=close_char) {
		debug::debug("ERROR: list_to_array: last character (" c ") is not the closing character (" close_char ")\n")
		exit(1)
	}
	debug::debug("|" str "|")
	str=substr(str, 2, len-2)
	len=length(str)
	while(len) {
		debug::debug(" => |" str "|")
		c=substr(str, 1, 1)
		if(c==open_char) {
			i=find_matching(str, 1, open_char, close_char)
			if(i<2) {
				return 0
			} else if(! list_to_array(substr(str, 1, i), open_char, close_char, sep_char, a[++a[0]])) {
				return 0
			} else {
				str=substr(str, i+1)
			}
		} else if(c==close_char) {
			return 0
		} else {
			i=index(str, sep_char)
			if(i==0) {
				a[++a[0]]=str
				str=""
			} else {
				a[++a[0]]=substr(str, 1, i-1)
				str=substr(str, i)
			}
		}
		if(substr(str, 1, 1)==sep_char) {
			str=substr(str, 2)
		}
		len=length(str)
	}
	debug::debug("\n")
	return 1
}

# vim: set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab textwidth=0:
