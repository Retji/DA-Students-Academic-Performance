 
 -- creating a database to store my tables downloaded from entrylevel--   
 
 create database entrylevel;
 
 -- selecting the database to use-- 
 use	entrylevel;
 
  -- the three four table  student_academic_info,county_info, student_family_details and student_personal_detail are imported as tables on mysql workbench-- 
 
  -- Returning all the columns in each of the tables-- 
 
 select	* from student_personal_details;
 select	* from student_family_details;
 select	* from county_info;
 select	* from student_academic_info;
 


-- Query 1: This query is to obtain a count of the number students and group them by gender from only the student_personal_details file without taking note of repetition-- 
select 	gender,
	count(*) as gender_count
from	student_personal_details
group 	by  gender;


-- Query 2: -- 
-- Create a summary table to obtain the education_class, average score, average tuition paid, the average wage of parents, and the number of students in the class-- 
-- the average passmark is 50 hence a class average score of below 50 is regarded as generally failed-- 

select 	education,
	round(avg(academic_score),2) as average_score,
	round(avg(student_tuition),2) as average_tuition,
	round(avg(wage),2) as average_wage,
case
	when avg(academic_score)>50 then "pass"
	else	"fail" 
end 
as 	remark
from 		student_academic_info
	inner 	join student_personal_details
			using	(id)
	inner	join student_family_details
			using	(id)
	inner	join county_info
			using 	(id)
	group 	by education
	order 	by education;
    

 -- Query 3: Joining all four tables to create a single table by full join of all ids including county_info id--  
create table	academic_info as(
			select *,
				case
					when 	avg(academic_score)>50 then "pass"
					else	"fail" 
					end 
							as 	remark
					from 	student_academic_info
					full 	join student_personal_details
							using	(id)
					left	join student_family_details
							using	(id)
					left 	join county_info
							using 	(id)
					group 	by id,education 	 --  the group by  removes where id, and education are repeated-- 
					order 	by education);
			
-- Query 4: View each candidate and whether the candidate has passed or fail--  
select 	id,
	round(academic_score,2) as academic_score,
        education,
        student_tuition,
        fcollege,
        mcollege,
        wage,
        round(distance,1) as distance,
        remark
from 	academic_info;


-- Query 5: This query returns the number of students by education years of education received using group by-- 
select	education,
        count(*) as number_of_students
from 	academic_info
group 	by education
order 	by education;

        
-- Query 6: This query gives a summary students who have pass and students that have failed by partitioning them--
	
select	education,
	gender,
	remark,
	count(*) over (partition by education,remark order by education) as number_of_students
from 	academic_info;




-- Query 7: Grouping of classes by colleges,income,distance
select	education,
	remark,
        gender,
        fcollege,
        mcollege,
        urban,
        income,
        unemp,
        wage,
        distance,
        ethnicity,
	count(*) as number_of_students
from 	academic_info
group 	by education,remark,gender,fcollege,mcollege,urban,income,unemp,wage,distance,ethnicity;

-- Querry 7b: partioning instead of group by--  
select	education,
	remark,
        gender,
        fcollege,
        mcollege,
        urban,
        income,
        unemp,
        wage,
        distance,
        ethnicity,
	count(*) over 	(partition by education,remark,gender,fcollege,mcollege,urban,income,unemp,wage,distance,ethnicity order by education) as number_of_students
from 	academic_info;
