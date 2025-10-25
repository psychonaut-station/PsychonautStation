/proc/random_code(n_length = 0)
	if(!n_length) //incase someone forgets to say how long they want the code to be
		stack_trace("No code length forwarded as argument")
	while(length(.) < n_length)
		. += "[rand(0, 9)]" // we directly write into the return value (.) here
