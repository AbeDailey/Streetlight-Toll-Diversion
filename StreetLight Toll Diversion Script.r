## R StreetLight Toll Diversion Script

## Abraham Dailey

## adailey@gpcog.org

## abraham.dailey@gmail.com

## 2020 10 15


## The purpose of this script is to calculate the following metrics using data contained in StreetLight Analysis files:
##   # Total trips between origin and destination zone
##   # Total trips between origin and destination through middle filter zones
##   # Percent error between values in previous two columns, and
##   # Trip distribution through middle filter zones


## Input: The input is a CSV file located in the root level of a StreetLight analysis folder downloaded from the StreetLight Insight platform.


## Output: The output will be a CSV file saved in the project folder. 

## The CSV file will identify:
##   # the task number from the scope of work, 
##   # the name of the analysis, 
##   # the origin zone, 
##   # the destination zone, 
##   # the middle filter zones, 
##   # total trips between origin and destination zone, 
##   # total trips through middle filter zone 1,
##   # total trips through middle filter zone 2,
##   # total trips through middle filter zone 3,
##   # total trips between origin and destination through middle filter zones, and
##   # the percent error between the values in the previous two columns. 

## Separate CSV files will be saved for different time periods and days of the week. 


## Follow these instructions to run this script:

## This script is set to run from "R Scripts/Percent Error" in the Gray Diversion Study project folder. 
## The file paths will need to be redefined using the following global variable if the script is moved to a different location:

## ToDo: add global variable referenced above

## This sets the global script_path variable to the current working directory in R

script_path <- getwd()


## Import R Libraries


## Set Environmental Variables



## Define Global Constants

column_names <- c("Task", "Analysis", "Origin Zone", "Destination Zone", "Middle Filter Zone 1", "Middle Filter Zone 2", "Middle Filter Zone 3", "Middle Filter Zone 4", "O-D Total", "MF1 Total", "MF2 Total", "MF3 Total", "MF4 Total", "MF1 Percent", "MF2 Percent", "MF3 Percent", "MF4 Percent", "Other Percent", "OD-MF Total", "Absolute Error","Percentage Error")

result_column_names <- c("MF1 Total", "MF2 Total", "MF3 Total", "MF4 Total", "OD-MF Total")

data_row_column_names <- c("O-D Total", "MF1 Total", "MF2 Total", "MF3 Total", "MF4 Total", "MF1 Percent", "MF2 Percent", "MF3 Percent", "MF4 Percent", "Other Percent", "OD-MF Total", "Absolute Error", "Percentage Error")



od_list <- c("Task 2A;NB;OD;I-95 NB South of Exit 63;Northern Analysis Area;Northbound Trips to Northern Analysis Area.csv", 
             "Task 2A;NB;OD;I-95 NB South of Exit 63;Northern Analysis Area;Northbound Trips to Northern Analysis Area.csv", 
             "Task 2A;SB;OD;Northern Analysis Area;I-95 SB South of Exit 63;Southbound Trips from Northern Analysis Area.csv", 
             "Task 2A;SB;OD;Northern Analysis Area;I-95 SB South of Exit 63;Southbound Trips from Northern Analysis Area.csv", 
             "Task 2B;SB;OD;I-95 SB North of Exit 75;I-95 SB South of Exit 63;Southbound Trips Exiting in Auburn and Re-entering Turnpike in Gray.csv", 
             "Task 2B;SB;OD;I-95 SB North of Exit 75;I-95 SB South of Exit 63;Southbound Trips Exiting in Auburn and Re-entering Turnpike in Gray.csv", 
             "Task 4A;NB;OD;Southern Analysis Area;I-95 NB North of Exit 75;Northbound Trips from Southern Analysis Area.csv", 
             "Task 4A;NB;OD;Southern Analysis Area;I-95 NB North of Exit 75;Northbound Trips from Southern Analysis Area.csv", 
             "Task 4A;SB;OD;I-95 SB North of Exit 75;Southern Analysis Area;Southbound Trips to Southern Analysis Area.csv", 
             "Task 4A;SB;OD;I-95 SB North of Exit 75;Southern Analysis Area;Southbound Trips to Southern Analysis Area.csv", 
             "Task 4A;SB;OD;I-95 SB North of Exit 75;Southern Analysis Area;Southbound Trips to Southern Analysis Area.csv", 
             "Task 4A;SB;OD;I-95 SB North of Exit 75;Southern Analysis Area;Southbound Trips to Southern Analysis Area.csv", 
             "Task 4A;SB;OD;I-95 SB North of Exit 75;Southern Analysis Area;Southbound Trips to Southern Analysis Area 2019.csv", 
             "Task 4A;SB;OD;I-95 SB North of Exit 75;Southern Analysis Area;Southbound Trips to Southern Analysis Area 2019.csv", 
             "Task 4A;SB;OD;I-95 SB North of Exit 75;Southern Analysis Area;Southbound Trips to Southern Analysis Area 2019.csv", 
             "Task 4B;NB;OD;I-95 NB South of Exit 63;I-95 NB North of Exit 75;Northbound Trips Exiting in Gray and Re-entering Turnpike in Auburn.csv", 
             "Task 4B;NB;OD;I-95 NB South of Exit 63;I-95 NB North of Exit 75;Northbound Trips Exiting in Gray and Re-entering Turnpike in Auburn.csv", 
             "Task 6;NB;OD;Route 202 EB West of Exit 63;Short Trips Analysis Area;Northbound Short Trips.csv", 
             "Task 6;NB;OD;Route 202 EB West of Exit 63;Short Trips Analysis Area;Northbound Short Trips.csv", 
             "Task 6;SB;OD;Short Trips Analysis Area;Route 202 WB West of Exit 63;Southbound Short Trips.csv",
             "Task 6;SB;OD;Short Trips Analysis Area;Route 202 WB West of Exit 63;Southbound Short Trips.csv")


 mf_list <- c("Task 2A;NB;2MF;I-95 North of Exit 63 Northbound;I-95 NB Exit 63 Offramp;Northbound Trips to Northern Analysis Area.csv",
             "Task 2A;NB;3MF;I-95 North of Exit 63 Northbound;ME-26 Northbound at Poland_NG Town Line;ME-4 Northbound at Auburn_NG Town Line;Northbound Trips to Northern Analysis Area.csv",
             "Task 2A;SB;2MF;I-95 North of Exit 63 Southbound;I-95 Exit 63 SB Onramp;Southbound Trips from Northern Analysis Area.csv", 
             "Task 2A;SB;3MF;I-95 North of Exit 63 Southbound;ME-26 Southbound at Poland_NG Town Line;ME-4 Southbound at Auburn_NG Town Line;Southbound Trips from Northern Analysis Area.csv",
             "Task 2B;SB;2MF;I-95 North of Exit 63 Southbound;I-95 SB Exit 75 Offramp;Southbound Trips Exiting in Auburn and Re-entering Turnpike in Gray.csv", 
             "Task 2B;SB;3MF;I-95 North of Exit 63 Southbound;ME-26 Southbound at Poland_NG Town Line;ME-4 Southbound at Auburn_NG Town Line;Southbound Trips Exiting in Auburn and Re-entering Turnpike in Gray.csv",
             "Task 4A;NB;2MF;I-95 North of Exit 63 Northbound;I-95 Exit 75 NB Onramp;Northbound Trips from Southern Analysis Area.csv", 
             "Task 4A;NB;3MF;I-95 North of Exit 63 Northbound;ME-4 Northbound at Auburn_NG Town Line;ME-26 Northbound at Poland_NG Town Line;Northbound Trips from Southern Analysis Area.csv",
             "Task 4A;SB;2MF;I-95 North of Exit 63 Southbound;I-95 Exit 63 SB Onramp;Southbound Trips to Southern Analysis Area V1.csv",
             "Task 4A;SB;3MF;I-95 North of Exit 63 Southbound;Route 202 EB East of Exit 63;Route 26A SB North of Route 202;Southbound Trips to Southern Analysis Area.csv", 
             "Task 4A;SB;4MF;I-95 North of Exit 63 Southbound;Route 202 WB East of Exit 63;Route 26A SB North of Route 202;Route 202 EB West of Exit 63;Southbound Trips to Southern Analysis Area.csv", 
             "Task 4A;SB;3MF;I-95 North of Exit 63 Southbound;ME-26 Southbound at Poland_NG Town Line;ME-4 Southbound at Auburn_NG Town Line;Southbound Trips to Southern Analysis Area.csv",
             "Task 4A;SB;2MF;I-95 North of Exit 63 Southbound;I-95 Exit 63 SB Onramp;Southbound Trips to Southern Analysis Area V1 2019.csv",
             "Task 4A;SB;3MF;I-95 North of Exit 63 Southbound;Route 202 EB East of Exit 63;Route 26A SB North of Route 202;Southbound Trips to Southern Analysis Area V4 2019.csv", 
             "Task 4A;SB;3MF;I-95 North of Exit 63 Southbound;ME-26 Southbound at Poland_NG Town Line;ME-4 Southbound at Auburn_NG Town Line;Southbound Trips to Southern Analysis Area 2019.csv",
             "Task 4B;NB;2MF;I-95 North of Exit 63 Northbound;I-95 NB Exit 63 Offramp;Northbound Trips Exiting in Gray and Re-entering Turnpike in Auburn.csv",
             "Task 4B;NB;3MF;I-95 North of Exit 63 Northbound;ME-26 Northbound at Poland_NG Town Line;ME-4 Northbound at Auburn_NG Town Line;Northbound Trips Exiting in Gray and Re-entering Turnpike in Auburn.csv",
             "Task 6;NB;3MF;Gray Task 6 Route 202 EB East of Exit 63;Gray Task 6 Route 26A NB north or Route 202;I-95 Exit 63 NB Onramp;Northbound Short Trips.csv", 
             "Task 6;NB;3MF;I-95 North of Exit 63 Northbound;ME-26 Northbound at Poland_NG Town Line;ME-4 Northbound at Auburn_NG Town Line;Northbound Short Trips.csv",
             "Task 6;SB;3MF;Gray Task 6 Route 202 WB East of Exit 63;Gray Task 6 Route 26A SB north or Route 202;I-95 Exit 63 SB Offramp;Southbound Short Trips.csv",
             "Task 6;SB;3MF;I-95 North of Exit 63 Southbound;ME-4 Southbound at Auburn_NG Town Line;ME-26 Southbound at Poland_NG Town Line;Southbound Short Trips.csv")

 ## 
## Define Global Variables


## Define Functions


## Subset data

## This function will subset data from the StreetLight output file by the day type and day part specified by the user
## The input for this function is a data frame containing the raw StreetLight data
## The output of this function is a data frame containing the StreetLight data for the day type and day part specified by the user

## Possible values for Day Type:

##  # 0: All Days (M-Su)
##  # 1: Weekday (M-Th)
##  # 2: Weekend Day (Sa-Su)

## Possible values for Day Part:

##  # 0: All Day (12am-12am)
##  # 1: Peak AM (6am-10am)
##  # 2: Mid-Day (10am-3pm)
##  # 3: Peak PM (3pm-7pm)

subset_data <- function(analysis_data, day_type, day_part) {

  ## select the records from the input data where Day.Type is equal to day_type and where Day.Part is equal to day_part
	analysis_data_subset <- analysis_data[ which(analysis_data$Day.Type==paste(day_type) & analysis_data$Day.Part==paste(day_part)), ]

	## return the subset of the original data
	return(analysis_data_subset)

} ## End subset_data function




## Calculate totals for O-D analyses

## This function will calculate the total trips between an origin and destination for the day type and day part specified by the user
## The input for this function is a data frame containing the raw StreetLight data
## The output of this function is the total trips between the origin and destination zone for the specified day type and day part

## Possible values for Day Type:

##  # 0: All Days (M-Su)
##  # 1: Weekday (M-Th)
##  # 2: Weekend Day (Sa-Su)

## Possible values for Day Part:

##  # 0: All Day (12am-12am)
##  # 1: Peak AM (6am-10am)
##  # 2: Mid-Day (10am-3pm)
##  # 3: Peak PM (3pm-7pm)

Calculate_OD_Totals <- function (analysis_name, day_type, day_part) {

  ## Read in the CSV file specified by the user
	O_D_Data <- read.csv(paste(analysis_name), header = TRUE)

	## Call the subset_data function to subset the raw data by day type and day part
	O_D_Data_Subset <- subset_data(O_D_Data, day_type, day_part)

	## Calculate the total trips between origin and destination in the subsetted data
	## Note: in this case the Total O-D trips (StreetLight Index) is in column 14
	## You may need to adjust this column number for other analysis types
	O_D_Total <- sum(O_D_Data_Subset[,14]) ## ToDo Substitute variable for column number?

	## Return the total trips between origin and destination for the day type and day part specified by the user
	return(O_D_Total)

} ## End Calculate_OD_Totals function



## Calculate totals for O-D with 2 Middle filter analyses

## This function will calculate the total trips between an origin and destination through middle filter zones for the day type and day part specified by the user
## This function is designed for StreetLight analyses with only two middle filter zones
## A value of 0 will be used for middle filter zone 3 - to serve as a placeholder. This is to make it easier to combine this data with the data for 3 middle filter analyses

## The input for this function is a data frame containing the raw StreetLight data
## The output of this function is a data frame containing:
## 1: Total trips between origin and destination through Middle Filter zone 1
## 2: Total trips between origin and destination through Middle Filter zone 2
## 3: Total trips between origin and destination through Middle Filter zone 3 - which is equal to 0 by definition for this function
## 4: Total trips between origin and destination through Middle Filter zones 1-3

## Possible values for Day Type:

##  # 0: All Days (M-Su)
##  # 1: Weekday (M-Th)
##  # 2: Weekend Day (Sa-Su)

## Possible values for Day Part:

##  # 0: All Day (12am-12am)
##  # 1: Peak AM (6am-10am)
##  # 2: Mid-Day (10am-3pm)
##  # 3: Peak PM (3pm-7pm)

## The Middle Filter zones are specified in the file name

Calculate_OD_2MF_Totals <- function (analysis_name, day_type, day_part, middle_filter_1, middle_filter_2) {

  ## Read in the CSV file specified by the user
	O_D_MF_Data <- read.csv(paste(analysis_name), header = TRUE)
	
	## Call the subset_data function to subset the raw data by day type and day part
	O_D_MF_Data_Subset <- subset_data(O_D_MF_Data, day_type, day_part)

	## select the records from the input data where Middle.Filter is equal to middle_filter_1
	middle_filter_1 <- O_D_MF_Data_Subset[ which(O_D_MF_Data_Subset$Middle.Filter.Zone.Name==paste(middle_filter_1)), ]
	
	## select the records from the input data where Middle.Filter is equal to middle_filter_2
	middle_filter_2 <- O_D_MF_Data_Subset[ which(O_D_MF_Data_Subset$Middle.Filter.Zone.Name==paste(middle_filter_2)), ]

	
	## Calculate the total trips between origin and destination through middle filter zone 1
	## Note: in this case the Total O-D trips (StreetLight Index) is in column 18
	## You may need to adjust this column number for other analysis types
	middle_filter_1_subtotal <- sum(middle_filter_1[,18]) ## ToDo Substitute variable for column number?
	
	## Calculate the total trips between origin and destination through middle filter zone 2
	## Note: in this case the Total O-D trips (StreetLight Index) is in column 18
	## You may need to adjust this column number for other analysis types
	middle_filter_2_subtotal <- sum(middle_filter_2[,18]) ## ToDo Substitute variable for column number?

	## The total trips through middle filter zone 3 is zero here because there is no middle filter zone 3. This is just a placeholder
	middle_filter_3_subtotal <- 0
	
	## The total trips through middle filter zone 4 is zero here because there is no middle filter zone 4. This is just a placeholder
	middle_filter_4_subtotal <- 0

	## Calculate the total trips between origin and destination through all middle filter zones
	## Note: in this case the Total O-D trips (StreetLight Index) is in column 18
	## You may need to adjust this column number for other analysis types
	O_D_MF_Total <- sum(O_D_MF_Data_Subset[,18]) ## ToDo Substitute variable for column number?

	## The result is a data frame containing:
	## 1: Total trips through middle filter 1
	## 2: Total trips through middle filter 2
	## 3: Total trips through middle filter 3
	## 4: Total trips through all three middle filters
	result <- data.frame(middle_filter_1_subtotal, middle_filter_2_subtotal, middle_filter_3_subtotal, middle_filter_4_subtotal, O_D_MF_Total)

	## Define the column names for the result data frame
	## result_column_names is a global variable set at the beginning of this script
	## We need to use consistent column names for joining data frames later
	colnames(result) <- result_column_names 

	## Return the result data frame as the output of this function
	return(result)

} ## End Calculate_OD_2MF_Totals function



## Calculate totals for O-D with 3 Middle filter analyses

## This function will calculate the total trips between an origin and destination through middle filter zones for the day type and day part specified by the user
## This function is designed for StreetLight analyses with only three middle filter zones

## The input for this function is a data frame containing the raw StreetLight data
## The output of this function is a data frame containing:
## 1: Total trips between origin and destination through Middle Filter zone 1
## 2: Total trips between origin and destination through Middle Filter zone 2
## 3: Total trips between origin and destination through Middle Filter zone 3
## 4: Total trips between origin and destination through Middle Filter zones 1-3

## Possible values for Day Type:

##  # 0: All Days (M-Su)
##  # 1: Weekday (M-Th)
##  # 2: Weekend Day (Sa-Su)

## Possible values for Day Part:

##  # 0: All Day (12am-12am)
##  # 1: Peak AM (6am-10am)
##  # 2: Mid-Day (10am-3pm)
##  # 3: Peak PM (3pm-7pm)

## The Middle Filter zones are specified in the file name

Calculate_OD_3MF_Totals <- function (analysis_name, day_type, day_part, middle_filter_1, middle_filter_2, middle_filter_3) {

  ## Read in the CSV file specified by the user
	O_D_MF_Data <- read.csv(paste(analysis_name), header = TRUE)

	## analysis_name_cleaned <- gsub("_", "/", analysis_name)
	
	## Call the subset_data function to subset the raw data by day type and day part
	O_D_MF_Data_Subset <- subset_data(O_D_MF_Data, day_type, day_part)

	## select the records from the input data where Middle.Filter is equal to middle_filter_1
	middle_filter_1 <- O_D_MF_Data_Subset[ which(O_D_MF_Data_Subset$Middle.Filter.Zone.Name==paste(middle_filter_1)), ]

	## select the records from the input data where Middle.Filter is equal to middle_filter_2
	middle_filter_2 <- O_D_MF_Data_Subset[ which(O_D_MF_Data_Subset$Middle.Filter.Zone.Name==paste(middle_filter_2)), ]

	## select the records from the input data where Middle.Filter is equal to middle_filter_3
	middle_filter_3 <- O_D_MF_Data_Subset[ which(O_D_MF_Data_Subset$Middle.Filter.Zone.Name==paste(middle_filter_3)), ]

	## Calculate the total trips between origin and destination through middle filter zone 1
	## Note: in this case the Total O-D trips (StreetLight Index) is in column 18
	## You may need to adjust this column number for other analysis types
	middle_filter_1_subtotal <- sum(middle_filter_1[,18]) ## ToDo Substitute variable for column number?

	## Calculate the total trips between origin and destination through middle filter zone 2
	## Note: in this case the Total O-D trips (StreetLight Index) is in column 18
	## You may need to adjust this column number for other analysis types
	middle_filter_2_subtotal <- sum(middle_filter_2[,18]) ## ToDo Substitute variable for column number?

	## Calculate the total trips between origin and destination through middle filter zone 3
	## Note: in this case the Total O-D trips (StreetLight Index) is in column 18
	## You may need to adjust this column number for other analysis types
	middle_filter_3_subtotal <- sum(middle_filter_3[,18]) ## ToDo Substitute variable for column number?
	
	## The total trips through middle filter zone 4 is zero here because there is no middle filter zone 4. This is just a placeholder
	middle_filter_4_subtotal <- 0

	## Calculate the total trips between origin and destination through all middle filter zones
	## Note: in this case the Total O-D trips (StreetLight Index) is in column 18
	## You may need to adjust this column number for other analysis types
	O_D_MF_Total <- sum(O_D_MF_Data_Subset[,18]) ## ToDo Substitute variable for column number?

	## The result is a data frame containing:
	## 1: Total trips through middle filter 1
	## 2: Total trips through middle filter 2
	## 3: Total trips through middle filter 3
	## 4: Total trips through all three middle filters
	result <- data.frame(middle_filter_1_subtotal, middle_filter_2_subtotal, middle_filter_3_subtotal, middle_filter_4_subtotal, O_D_MF_Total)

	## Define the column names for the result data frame
	## result_column_names is a global variable set at the beginning of this script
	## We need to use consistent column names for joining data frames later
	colnames(result) <- result_column_names 

	## Return the result data frame as the output of this function
	return(result)

} ## End Calculate_OD_3MF_Totals function


## Calculate totals for O-D with 4 Middle filter analyses

## This function will calculate the total trips between an origin and destination through middle filter zones for the day type and day part specified by the user
## This function is designed for StreetLight analyses with only four middle filter zones

## The input for this function is a data frame containing the raw StreetLight data
## The output of this function is a data frame containing:
## 1: Total trips between origin and destination through Middle Filter zone 1
## 2: Total trips between origin and destination through Middle Filter zone 2
## 3: Total trips between origin and destination through Middle Filter zone 3
## 4: Total trips between origin and destination through Middle Filter zone 4
## 5: Total trips between origin and destination through Middle Filter zones 1-4

## Possible values for Day Type:

##  # 0: All Days (M-Su)
##  # 1: Weekday (M-Th)
##  # 2: Weekend Day (Sa-Su)

## Possible values for Day Part:

##  # 0: All Day (12am-12am)
##  # 1: Peak AM (6am-10am)
##  # 2: Mid-Day (10am-3pm)
##  # 3: Peak PM (3pm-7pm)

## The Middle Filter zones are specified in the file name

Calculate_OD_4MF_Totals <- function (analysis_name, day_type, day_part, middle_filter_1, middle_filter_2, middle_filter_3, middle_filter_4) {
  
  ## Read in the CSV file specified by the user
  O_D_MF_Data <- read.csv(paste(analysis_name), header = TRUE)
  
  ## analysis_name_cleaned <- gsub("_", "/", analysis_name)
  
  ## Call the subset_data function to subset the raw data by day type and day part
  O_D_MF_Data_Subset <- subset_data(O_D_MF_Data, day_type, day_part)
  
  ## select the records from the input data where Middle.Filter is equal to middle_filter_1
  middle_filter_1 <- O_D_MF_Data_Subset[ which(O_D_MF_Data_Subset$Middle.Filter.Zone.Name==paste(middle_filter_1)), ]
  
  ## select the records from the input data where Middle.Filter is equal to middle_filter_2
  middle_filter_2 <- O_D_MF_Data_Subset[ which(O_D_MF_Data_Subset$Middle.Filter.Zone.Name==paste(middle_filter_2)), ]
  
  ## select the records from the input data where Middle.Filter is equal to middle_filter_3
  middle_filter_3 <- O_D_MF_Data_Subset[ which(O_D_MF_Data_Subset$Middle.Filter.Zone.Name==paste(middle_filter_3)), ]
  
  ## select the records from the input data where Middle.Filter is equal to middle_filter_3
  middle_filter_4 <- O_D_MF_Data_Subset[ which(O_D_MF_Data_Subset$Middle.Filter.Zone.Name==paste(middle_filter_4)), ]
  
  ## Calculate the total trips between origin and destination through middle filter zone 1
  ## Note: in this case the Total O-D trips (StreetLight Index) is in column 18
  ## You may need to adjust this column number for other analysis types
  middle_filter_1_subtotal <- sum(middle_filter_1[,18]) ## ToDo Substitute variable for column number?
  
  ## Calculate the total trips between origin and destination through middle filter zone 2
  ## Note: in this case the Total O-D trips (StreetLight Index) is in column 18
  ## You may need to adjust this column number for other analysis types
  middle_filter_2_subtotal <- sum(middle_filter_2[,18]) ## ToDo Substitute variable for column number?
  
  ## Calculate the total trips between origin and destination through middle filter zone 3
  ## Note: in this case the Total O-D trips (StreetLight Index) is in column 18
  ## You may need to adjust this column number for other analysis types
  middle_filter_3_subtotal <- sum(middle_filter_3[,18]) ## ToDo Substitute variable for column number?
  
  ## Calculate the total trips between origin and destination through middle filter zone 3
  ## Note: in this case the Total O-D trips (StreetLight Index) is in column 18
  ## You may need to adjust this column number for other analysis types
  middle_filter_4_subtotal <- sum(middle_filter_4[,18]) ## ToDo Substitute variable for column number?
  
  ## Calculate the total trips between origin and destination through all middle filter zones
  ## Note: in this case the Total O-D trips (StreetLight Index) is in column 18
  ## You may need to adjust this column number for other analysis types
  O_D_MF_Total <- sum(O_D_MF_Data_Subset[,18]) ## ToDo Substitute variable for column number?
  
  ## The result is a data frame containing:
  ## 1: Total trips through middle filter 1
  ## 2: Total trips through middle filter 2
  ## 3: Total trips through middle filter 3
  ## 4: Total trips through all three middle filters
  result <- data.frame(middle_filter_1_subtotal, middle_filter_2_subtotal, middle_filter_3_subtotal, middle_filter_4_subtotal, O_D_MF_Total)
  
  ## Define the column names for the result data frame
  ## result_column_names is a global variable set at the beginning of this script
  ## We need to use consistent column names for joining data frames later
  colnames(result) <- result_column_names 
  
  ## Return the result data frame as the output of this function
  return(result)
  
} ## End Calculate_OD_4MF_Totals function


## Create data row function

## This function will combine various data elements into one row that will be written to a CSV file later
## The inputs are the outputs from the Calculate_OD_Totals and Calculate_OD_2MF_Totals or Calculate_OD_3MF_Totals function2

## This function also calculates:
## 1: Absolute error - the absolute difference between total trips between o-d through mf and total trips between o-d
## 2: Percent error - the percent difference between total trips between o-d through mf and total trips between o-d, relative to total trips between o-d
## 3: Percent through middle filter zone 1, based on total trips between origin and destination
## 4: Percent through middle filter zone 2, based on total trips between origin and destination
## 5: Percent through middle filter zone 3, based on total trips between origin and destination

## The output of this function is a data frame containing the values outlined above.

create_data_row <- function(O_D_Total, O_D_MF_Totals) {

	absolute_error <- (O_D_Total-O_D_MF_Totals[5])
  
  percent_error <- absolute_error/O_D_Total
  
  percent_MF_1 <- O_D_MF_Totals[1]/O_D_Total
  
  percent_MF_2 <- O_D_MF_Totals[2]/O_D_Total
  
  percent_MF_3 <- O_D_MF_Totals[3]/O_D_Total
  
  percent_MF_4 <- O_D_MF_Totals[4]/O_D_Total
  
  percent_other <- absolute_error/O_D_Total

	row <- data.frame(O_D_Total, O_D_MF_Totals[1], O_D_MF_Totals[2], O_D_MF_Totals[3], O_D_MF_Totals[4], percent_MF_1, percent_MF_2, percent_MF_3, percent_MF_4, percent_other, O_D_MF_Totals[5], absolute_error, percent_error)

	colnames(row) <- data_row_column_names

	return(row)

} ## End create_data_row function



## Analysis for 2 middle filter analysis
## This function will calculate the total o-d trips using the O-D and O-D MF analyses for each task in the study
## This function is for StreetLight analyses with two middle filter zones

analysis_for_2_middle_filters <- function(od_name, mf_name, day_type, day_part, middle_filter_1, middle_filter_2) {

	O_D_Total <- Calculate_OD_Totals(od_name, day_type, day_part)
	O_D_MF_Totals <- Calculate_OD_2MF_Totals(mf_name, day_type, day_part, middle_filter_1, middle_filter_2)
	row <- create_data_row(O_D_Total, O_D_MF_Totals)
	
	return(row)

} ## End analysis_for_2_middle_filters function


## Analysis for 3 middle filter analysis
## This function will calculate the total o-d trips using the O-D and O-D MF analyses for each task in the study
## This function is for StreetLight analyses with three middle filter zones

analysis_for_3_middle_filters <- function(od_name, mf_name, day_type, day_part, middle_filter_1, middle_filter_2, middle_filter_3) {

	O_D_Total <- Calculate_OD_Totals(od_name, day_type, day_part)
	O_D_MF_Totals <- Calculate_OD_3MF_Totals(mf_name, day_type, day_part, middle_filter_1, middle_filter_2, middle_filter_3)
	row <- create_data_row(O_D_Total, O_D_MF_Totals)
	
	return(row)

} ## End analysis_for_3_middle_filters function



## Analysis for 4 middle filter analysis
## This function will calculate the total o-d trips using the O-D and O-D MF analyses for each task in the study
## This function is for StreetLight analyses with three middle filter zones

analysis_for_4_middle_filters <- function(od_name, mf_name, day_type, day_part, middle_filter_1, middle_filter_2, middle_filter_3, middle_filter_4) {
  
  O_D_Total <- Calculate_OD_Totals(od_name, day_type, day_part)
  O_D_MF_Totals <- Calculate_OD_4MF_Totals(mf_name, day_type, day_part, middle_filter_1, middle_filter_2, middle_filter_3, middle_filter_4)
  row <- create_data_row(O_D_Total, O_D_MF_Totals)
  
  return(row)
  
} ## End analysis_for_4_middle_filters function



## Parse Files

## This function will read through the list of StreetLight analysis files listed at the beginning of this script and execute a series of functions to calculate the results
## This function will also parse through information contained in the file names, such as the Task number, direction of travel, or middle filter zones
## That are used to run different functions in the script
## Users will need to rename the StreetLight analysis files so the names contain the information needed by the script
## See the user guide for more info (ToDo: make user guide)

parse_files <- function(od_list, mf_list, day_type, day_part) {

	od_count <- length(od_list)

	od_index <- 1

	mf_count <- length(mf_list)

	mf_index <- 1


	day_type_split <- unlist(strsplit(day_type, ": "))

	day_type_cleaned <- day_type_split[2]


	day_part_split <- unlist(strsplit(day_part, ": "))

	day_part_cleaned <- day_part_split[2]

	


	while(od_index<=od_count) {


		od_name <- od_list[od_index]

		od_name_split <- unlist(strsplit(od_name, ";"))

		od_task_number <- od_name_split[1]

		od_direction <- od_name_split[2]

		od_analysis_type <- od_name_split[3]

		od_origin_zone <- od_name_split[4]	

		od_destination_zone <- od_name_split[5]

		od_analysis_name <- unlist(strsplit(od_name_split[6], ".c"))[1]		



		mf_name <- mf_list[mf_index]

		mf_name_split <- unlist(strsplit(mf_name, ";"))

		mf_task_number <- mf_name_split[1]

		mf_direction <- mf_name_split[2]

		mf_analysis_type <- mf_name_split[3]

		mf_middle_filter_1 <- mf_name_split[4]	

		mf_middle_filter_2 <- mf_name_split[5]
		
		if(grepl("_", mf_middle_filter_2, fixed=TRUE)) {
		  
		  mf_middle_filter_2 <- gsub("_", "/", mf_middle_filter_2)
		  
		}
		
		
		## mf_middle_filter_2 <- str_replace_all(mf_middle_filter_2, "_", "////")

		mf_middle_filter_3 <- "Not Applicable"
		
		mf_middle_filter_4 <- "Not Applicable"

		
		if(mf_analysis_type=='2MF') {

			mf_analysis_name <- unlist(strsplit(mf_name_split[6], ".c"))[1]

			od_mf_results <- analysis_for_2_middle_filters(od_name, mf_name, day_type, day_part, mf_middle_filter_1, mf_middle_filter_2)

			data_row <- data.frame(od_task_number, od_analysis_name, od_origin_zone, od_destination_zone, mf_middle_filter_1, mf_middle_filter_2, mf_middle_filter_3, mf_middle_filter_4, od_mf_results)

			colnames(data_row) <- column_names


			if(od_index==1) {

				output_table <- data_row

				colnames(output_table) <- column_names

			} else {
			  
			  output_table <- rbind(output_table, data_row)

			}


			od_index <- od_index+1

			mf_index <- mf_index+1 
		}


		if(mf_analysis_type=='3MF') {

			mf_middle_filter_3 <- mf_name_split[6]
			
			if(grepl("_", mf_middle_filter_3, fixed=TRUE)) {
			  
			  mf_middle_filter_3 <- gsub("_", "/", mf_middle_filter_3)
			  
			}

			mf_middle_filter_4 <- "Not Applicable"
			
			mf_analysis_name <- unlist(strsplit(mf_name_split[7], ".c"))[1]

			
			od_mf_results <- analysis_for_3_middle_filters(od_name, mf_name, day_type, day_part, mf_middle_filter_1, mf_middle_filter_2, mf_middle_filter_3)

			data_row <- data.frame(od_task_number, od_analysis_name, od_origin_zone, od_destination_zone, mf_middle_filter_1, mf_middle_filter_2, mf_middle_filter_3, mf_middle_filter_4, od_mf_results)

			
			colnames(data_row) <- column_names

			if(od_index==1) {
			  
				output_table <- data_row

				colnames(output_table) <- column_names

			} else {

			  output_table <- rbind(output_table, data_row)

			}


			od_index <- od_index+1

			mf_index <- mf_index+1 

		}

		
		if(mf_analysis_type=='4MF') {
		  
		  mf_middle_filter_3 <- mf_name_split[6]
		  
		  mf_middle_filter_4 <- mf_name_split[7]
		  
		  if(grepl("_", mf_middle_filter_3, fixed=TRUE)) {
		    
		    mf_middle_filter_3 <- gsub("_", "/", mf_middle_filter_3)
		    
		  }
		  
		  if(grepl("_", mf_middle_filter_4, fixed=TRUE)) {
		    
		    mf_middle_filter_4 <- gsub("_", "/", mf_middle_filter_4)
		    
		  }
		  
		  
		  mf_analysis_name <- unlist(strsplit(mf_name_split[8], ".c"))[1]
		  
		  
		  od_mf_results <- analysis_for_4_middle_filters(od_name, mf_name, day_type, day_part, mf_middle_filter_1, mf_middle_filter_2, mf_middle_filter_3, mf_middle_filter_4)
		  
		  data_row <- data.frame(od_task_number, od_analysis_name, od_origin_zone, od_destination_zone, mf_middle_filter_1, mf_middle_filter_2, mf_middle_filter_3, mf_middle_filter_4, od_mf_results)
		  
		  
		  colnames(data_row) <- column_names
		  
		  if(od_index==1) {
		    
		    output_table <- data_row
		    
		    colnames(output_table) <- column_names
		    
		  } else {
		    
		    output_table <- rbind(output_table, data_row)
		    
		  }
		  
		  
		  od_index <- od_index+1
		  
		  mf_index <- mf_index+1 
		  
		}


	}
	
	write.table(output_table, file = paste("percentage_error_results_", day_type_cleaned, "_", day_part_cleaned, "_.csv", sep = ""), append = FALSE, sep = ",", row.names = FALSE, col.names = TRUE, qmethod = "double")

	


} ## parse_files function




## Main Part of Script

## Now that we have defined all variables, constants, and functions, we can run the main script

## This will involve running the parse_files script defined above
## The parse_files script will run a series of other functions and calculate the results we are looking for

## The input for the parse_files script is:
## 1: od_list: a list of origin-destination analyses outlined at the beginning of this script
## 2: mf_list: a list of origin-destination with middle filter analyses outlined at the beginning of this script
## 3: day_type: day type, see below
## 4: day_part: day part, see below

## Possible values for Day Type:

##  # 0: All Days (M-Su)
##  # 1: Weekday (M-Th)
##  # 2: Weekend Day (Sa-Su)

## Possible values for Day Part:

##  # 0: All Day (12am-12am)
##  # 1: Peak AM (6am-10am)
##  # 2: Mid-Day (10am-3pm)
##  # 3: Peak PM (3pm-7pm)

## Note: When you set up a StreetLight analysis it will number the day types and day parts and times of day starting at 0
## The numbers representing each day type or day part will change depending on how many day types and day parts are included in your analyses
## Be sure to be consistent with the day types and day parts included in your analyses, otherwise you will need to tailor this script based on the number
## of day types and day parts included in your analysis

## This command will run the parse_files function using the files listed at the beginning of the script
## The day type is Weekday and the day part is all day
parse_files(od_list, mf_list, "1: Weekday (M-Th)", "0: All Day (12am-12am)")
parse_files(od_list, mf_list, "1: Weekday (M-Th)", "1: Peak AM (6am-10am)")

## Note: this will have to be change to "2: Peak PM (3pm-7pm)" for analyses that do not contain the Mid-Day period (Task 2B, Task 4B, and Task 6)
## All other analyses should use "3: Peak PM (3pm-7pm)"
parse_files(od_list, mf_list, "1: Weekday (M-Th)", "2: Peak PM (3pm-7pm)")

parse_files(od_list, mf_list, "2: Weekend Day (Sa-Su)", "0: All Day (12am-12am)")

## To run this analysis for other day types or day parts, modify using examples above
## To run this analysis for other analyses modify the file lists od_list and mf_list


