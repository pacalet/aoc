@namespace "utils"

# Absolute value
function abs(val) {
	return (val<0)?-val:val
}

# Minimum of two numbers
function nmin(left, right) {
	return (left<right)?left:right
}

# Maximum of two numbers
function nmax(left, right) {
	return (left>right)?left:right
}

# Minimum of values in array of numbers, 0 if empty array
function amin(a,    k, m) {
	if(length(a)==0) {
		return 0
	}
	m="none"
	for(k in a) {
		if(m=="none" || m+0>a[k]+0) {
			m=a[k]
		}
	}
	return m
}

# Maximum of values in array of numbers, 0 if empty array
function amax(a,    k, m) {
	if(length(a)==0) {
		return 0
	}
	m="none"
	for(k in a) {
		if(m=="none" || m+0<a[k]+0) {
			m=a[k]
		}
	}
	return m
}

# Minimum of keys of array, 0 if empty array
function kmin(a,    k, m) {
	if(length(a)==0) {
		return 0
	}
	m="none"
	for(k in a) {
		if(m=="none" || m+0>k+0) {
			m=k
		}
	}
	return m
}

# Maximum of keys of array, 0 if empty array
function kmax(a,    k, m) {
	if(length(a)==0) {
		return 0
	}
	m="none"
	for(k in a) {
		if(m=="none" || m+0<k+0) {
			m=k
		}
	}
	return m
}

# Swap elements with keys i and j in array arr
function swap(arr, i, j,    tmp) {
	tmp=arr[i]
	arr[i]=arr[j]
	arr[j]=tmp
}

# Print array
function print_array(a,    prefix, key) {
	for(key in a) {
		printf("%s[%s] =", prefix, key)
		if(awk::isarray(a[key])) {
			printf("\n");
			print_array(a[key], prefix "  ")
		} else {
			printf(" %s\n", a[key])
		}
	}
}

# Copy array
function copy_array(a, b,    key) {
	delete b
	for(key in a) {
		if(awk::isarray(a[key])) {
			copy_array(a[key], b[key])
		} else {
			b[key]=a[key]
		}
	}
}

# Print array of characters. a[i][j] is the character of line i, column j.
# Indexes start at 0. The top-left character is a[0][0].
function print_screen(a,    i ,j) {
	for(i=0; i<length(a); i++) {
		for(j=0; j<length(a[i]); j++) {
			printf("%s", a[i][j])
		}
		printf("\n");
	}
}

# Return string `str` where all characters in string `from` have been replaced
# with corresponding character in string `to`. If strings `from` and `to` have
# different lengths the longest is truncated.
function tr(str, from, to,    nf, f, nt, t, i, ft, c, tmp) {
	nf=awk::patsplit(from, f, @/./)
	nt=awk::patsplit(to, t, @/./)
	for(i=1; i<=nmin(nf, nt); i++) {
		ft[f[i]]=t[i]
	}
	tmp=""
	for(i=1; i<=length(str); i++) {
		c=substr(str, i, 1)
		if(c in ft) {
			tmp=tmp ft[c]
		} else {
			tmp=tmp c
		}
	}
	return tmp
}

function keyvalswap(a, b,    k) {
	for(k in a) {
		b[a[k]]=k
	}
}

@namespace "awk"
