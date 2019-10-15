#This function multiplies the elements of a vector by 100 if theri sum is greater than 0
#otherwise, it just returns the vector
SomeOperation <- function(v){
	if(sum(v)>0){
		return (v*100)
	}
	return(v)
}

M <- matrix(rnorm(100), 10, 10)
print(M)
#Apply the function to a matrix M by rows. The result wil be output in columns, so it
#can be confusing
print(apply(M,1,SomeOperation))
