#Exercise 1 USING JOINS
#Q1 Write and execute a SQL query to list the school names, community names and average attendance for communities with a hardship index of 98.
SELECT NAME_OF_SCHOOL, COMMUNITY_AREA_NAME, AVG(AVERAGE_STUDENT_ATTENDANCE) 
FROM CHICAGO_PUBLIC_SCHOOLS AS SC INNER JOIN chicago_socioeconomic_data AS SE 
ON SC.COMMUNITY_AREA_NAME = SE.COMMUNITY_AREA_NAME 
WHERE SE.HARDSHIP_INDEX = 98; 
#Q2 Write and execute a SQL query to list all crimes that took place at a school. Include case number, crime type and community name.

#Exercise 2 CREATE VIEWS
#For privacy reasons, you have been asked to create a view that enables users to select just the school name and the 
#icon fields from the CHICAGO_PUBLIC_SCHOOLS table. By providing a view, you can ensure that users cannot see the actual scores given to a school, just the icon associated with their score. 
#You should define new names for the view columns to obscure the use of scores and icons in the original table.

#Q1 Write and execute a SQL statement to create a view showing the columns listed in the following table, with new column names as shown in the second column.
#Q2 Write and execute a SQL statement that returns all of the columns from the view.
#Q3 Write and execute a SQL statement that returns just the school name and leaders rating from the view.

CREATE VIEW VIEWW AS
SELECT NAME_OF_SCHOOL "SCHOOL_NAME", SAFETY_ICON "SAFETY_RATING",FAMILY_INVOLVEMENT_ICON "FAMILY RATING",
ENVIRONMENT_ICON "ENVIRONMENT_RATING",INSTRUCTION_ICON "INSTRUCTION_RATING", LEADERS_ICON "LEADERS_RATING",
TEACHERS_ICON "TEACHERS_RATING" FROM CHICAGO_PUBLIC_SCHOOLS;

SELECT * FROM VIEWW;
SELECT SCHOOL_NAME, LEADERS_RATING FROM VIEWW;

#Exercise 3&4  STORED PROCEDURES and transaction
#The icon fields are calculated based on the value in the corresponding score field. You need to make sure that when a score field is updated, the icon field is updated too. To do this, you will write a stored procedure that receives the school id and a leaders score as input parameters, calculates the icon setting and updates the fields appropriately.

#Q1 Write the structure of a query to create or replace a stored procedure called UPDATE_LEADERS_SCORE that takes a in_School_ID parameter as an integer and a in_Leader_Score parameter as an integer.
#Q2 Inside your stored procedure, write a SQL statement to update the Leaders_Score field in the CHICAGO_PUBLIC_SCHOOLS table for the school identified by in_School_ID to the value in the in_Leader_Score parameter.
#Q3 Inside your stored procedure, write a SQL IF statement to update the Leaders_Icon field in the CHICAGO_PUBLIC_SCHOOLS table for the school identified by in_School_ID using the following information.
#Q4 Write a query to call the stored procedure, passing a valid school ID and a leader score of 50, to check that the procedure works as expected.

#Exercise 4 USING TRANSACTIONS
#You realise that if someone calls your code with a score outside of the allowed range (0-99), then the score will be updated with the invalid data and the icon will remain at its previous value. There are various ways to avoid this problem, one of which is using a transaction.
#Q1 Update your stored procedure definition. Add a generic ELSE clause to the IF statement that rolls back the current work if the score did not fit any of the preceding categories.
#Q2 Update your stored procedure definition again. Add a statement to commit the current unit of work at the end of the procedure.


DELIMITER @
CREATE PROCEDURE UPDATE_LEADERS_SCORE(IN in_School_ID INT, IN in_Leader_Score INT)
BEGIN
	
	UPDATE CHICAGO_PUBLIC_SCHOOLS
	SET Leaders_Score = in_Leader_Score
	WHERE School_ID = in_School_ID ;
   		IF in_Leader_Score > 0 AND in_Leader_Score < 20 THEN
	      	UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Very Weak';
	    ELSEIF in_Leader_Score < 40 THEN
	       	UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET CHICAGO_PUBLIC_SCHOOLS.Leaders_Icon = 'Weak';	
	    ELSEIF in_Leader_Score < 60 THEN
	       	UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET CHICAGO_PUBLIC_SCHOOLS.Leaders_Icon = 'Average';
	    ELSEIF in_Leader_Score < 80 THEN
	       	UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET CHICAGO_PUBLIC_SCHOOLS.Leaders_Icon = 'Strong';
	    ELSEIF in_Leader_Score < 100 THEN
	       	UPDATE CHICAGO_PUBLIC_SCHOOLS.CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Very Strong';
		ELSE
        	ROLLBACK WORK;

	   	END IF;
	commit work;
END IF;
END
@            

CALL UPDATE_LEADERS_SCORE(610038,101);
SELECT LEADERS_ICON, LEADERS_SCORE, SCHOOL_ID FROM chicago_public_schools;
   
