# CourseraGetClean
Getting and Cleaning Data Project in Coursera

There are two files in this repo:
1. run_analysis.R
2. codebook.txt

1. First file: run_analysis.R
This first file contains the script to process the provided data files as directed by the project prompt.
The script within the file is divided into different subsections according to the directions given on Coursera.
The subsections are:
	a. Getting all the files from the directory and storing them into variables
				Using "fread" function
	b. Step 1: Merging the train and test datasets
				Done by using "rbind" and "cbind" functions appropriately to the variables in subsection a.
	c. Step 2: Extracting only the variables within the dataset from b. that contain mean and standard deviation values
				Done by using the "grepl" function to return a logical vector of variables that contain "mean()" and "std()" in their names
				Afterwards, the "which" function is applied to the grepl function to return the index of true values within the logical vector.
				Finally, the tidy data set is constructed by subsetting the main merged dataset using the column numbers obtained by using the
				"grepl" and "which" functions.
	d. Step 3: Assign descriptive activity names into the dataset
				This is performed by converting the "Activity" column within the tidy data set into a factor, and relabeling the levels
				using the activity names stored in the "activities" variable.
	e. Step 4: Rename the variables within the dataset into descriptive names
				Many substitutions were done to the variable names in the tidy data set using the "gsub" function to end up with 
				descriptive names
	f. Step 5: Create a second tidy data set that contains the average of all variables within the subjects and activities
				The second tidy dataset is created by sending the first tidy data set into the pipeline, and performing 1) "group_by" function
				to group the rows in the data set according to the subject ID and activity and 2) "summarize_all(mean)" function to obtain the mean
				of each variable for each observation in the data set.
	
2. Second file: codebook.txt
This file contains all the variable names that are created within th run_analysis.R file with the description of what the variables do
