extends Node2D
class_name Matrix



var selection_vector=Vector2()



func initalize_total_value_matrix(rows,colums,value):
	var m=[]
	for i in range(rows):
		var temp=[]
		for j in range(colums):
			if(typeof(value)!=TYPE_ARRAY):
				temp.append(value)
			else:
				temp.append(value.duplicate())
		m.append_array([temp])
	return m


func set_values(matrix,value,row,colum):
		matrix[row-1][colum-1]=value

func fill_rows(matrix,value,row,colums):
	for j in range(colums):
		matrix[row-1][j]=value

func fill_colums(matrix,value,colum,rows):
	for i in range(rows):
		matrix[i][colum-1]=value

func print_matrix(matrix):
	var rows=len(matrix)
	var colums=len(matrix[0])
	var temp_matrix=[]
	for i in range(rows):
		var temp=[]
		for j in range(colums):
			temp.append(matrix[i][j])
		temp_matrix.append_array([temp])
		print(temp_matrix[i])







func add_matrix(arr):
	var result_matrix=[]
	var Factors=equal_rows_and_colums(arr)
	"""Addition of the matrix take place"""
	if Factors[0]:
		result_matrix=initalize_total_value_matrix(Factors[1],Factors[2],0)
		for i in range(len(arr)):
			for j in range(Factors[1]):
				for k in range(Factors[2]):
					result_matrix[j][k]+=arr[i][j][k]
	return result_matrix


func equal_rows_and_colums(arr):
	var rowlengths=get_row_count(arr)
	var first_num=rowlengths[0]
	var isequalrows=true
	for i in rowlengths:
		if(i!=first_num):
			printerr("Cant add those matrixes")
			isequalrows=false
		
	#for colum we have to go to the indival element of the first row and add those 
	#values
	var colum_lengths=get_colum_count(arr)
	var first_colum=colum_lengths[0]
	var isequalcolum=true
	
	for i in colum_lengths:
		if(i!=first_colum):
			isequalcolum=false
	
	return [true,first_num,first_colum] if (isequalcolum&&isequalrows) else [false,0,0]


func get_colum_count(arr):
	var colum_lengths=[]
	for i in range(len(arr)):
		var colum_sum=0
		for j in arr[i][0]:
			colum_sum+=1
		colum_lengths.append(colum_sum)
	return colum_lengths

func get_row_count(arr):
	var rowlengths=[]
	#for rows
	for i in range(len(arr)):
		var row_sum=0
		for j in arr[i]:
			row_sum+=1
		rowlengths.append(row_sum)
	return rowlengths


func multiply_matrix(matrixa,matrixb):
	var matrixa_row=len(matrixa)
	var matrixa_colum=len(matrixa[0])
	var matrixb_row=len(matrixb)
	var matrixb_colum=len(matrixb[0])
	if(matrixa_colum==matrixb_colum):
		var result_matrix=initalize_total_value_matrix(matrixa_row,matrixb_colum,0)
		for i in range(matrixa_row):
			for j in range(matrixb_colum):
				for k in range(matrixa_colum):
					result_matrix[i][j]+=matrixa[i][k]*matrixb[k][j]
		return result_matrix
	else:
		return 0

func select_element(matrix,row,colum):
	#used in select a particular element in a matrix returns a Position vector like for 
	#a11 it will be Vector2(1,1)
	var maximum_row_value=len(row)-1
	var maximum_col_value=len(colum)-1
	selection_vector.x+=1
	if (selection_vector.x>maximum_row_value):
			selection_vector.x=0
			selection_vector.y+=1
	if(selection_vector.y>maximum_col_value):
			selection_vector.y=0
	return (matrix[selection_vector.x][selection_vector.y])


func selection_matrix(matrix,row,colum,event=InputEventKey):
	if event.is_action_pressed("ui_right"):
			var ele=select_element(matrix,row,colum)
	elif event.is_action_pressed("ui_left"):
			var ele=select_element(matrix,row,colum)


