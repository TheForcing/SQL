%ORACLE_HOME%\demo\schema\human_resources\hr_main.sql
        -- 파라미터 1: HR계정 비밀번호 - hr
	-- 파라미터 2: 기본 테이블스페이스 - users
	-- 파라미터 3: 임시 테이블스페이스 - temp
	-- 파라미터 4: 로그 파일 위치 - %ORACLE_HOME%\demo\schema\log

----------
--Join
------------

--먼저 employees와 department 를 확인
DESC employees;
DESC departments;

-- 두 테이블로부터 모든 레코드를 추출 : cartision product or cross join
select first_name, emp.department_id, dept.department_id department_name
From employees emp, departments dept
Order by first_name;

-- 테이블 조인을 위한 조건 부여
select first_name, emp.department_id, dept.department_id, department_name
from employees emp, departments dept
where emp.department_id = dept.department_id;


-- 총 몇 명의 사원이 있는가?
select count(*) from employees;
select first_name, emp.department_id, department_name
from employees emp, departments dept
where emp.department_id= dept.department_id;  --- 106명


-- department_id 가 null인 사원?
select * from employees
where department_id is Null;

--USING : 조인할 컬럼을 명시
select first_name, department_name
from employees Join departments Using(department_id);

--ON: Join의 조건절
Select first_name, department_name
from employees emp Join departments dept 
                 ON (emp.department_id=dept.department_id); -- Join의 조건
                 
-- Natural join 
--조건 명시 하지 않고, 같은 이름을 가진 컬럼으로 JOIN
select first_name, department_name
from employees Natural JOIN departments;
-- 잘못된 쿼리 : Natural Join은 조건을 잘 확인;


-- THETA JOIN
-- JOIN 조건이 Equal 이 아닌 것
------------
--OUTER JOIN\
--------------
--조건이 만족하는 짝이 없는 튜플도 NULL을 포함해서 결과를 출력
--모든 레코드를 출력할 테이블 위치에 따라 LEFT, RIGHT, FULL OUTER JOIN으로 구분
--ORACLE의 경우 NULL을 출력할 조건 쪽에 (+)를 붙인다.

select first_name, 
emp.department_id,
dept.department_id,
department_name
From employees emp, departments dept
where emp.department_id=dept.department_id (+);

-- ANSI SQL
select emp.first_name,
emp.department_id,
dept.department_id,
dept.department_name
from employees emp left outer join departments dept
                     ON emp.department_id=dept.department_id;
                     
 --- RIGHT OUTER JOIN   짝이 없는 오른쪽 레코드도 null 을 포함하여 출력
 select first_name, emp.department_id,
 dept.department_id, dept.department_name
 from employees emp, departments dept
 where emp.department_id(+) =dept.department_id;
 
 --ANSI SQL
 Select emp.first_name, emp.department_id,
 dept.department_id,dept.department_name
 from employees emp Right OUTER JOIN departments dept
                       On emp.department_id = dept.department_id;
                       
--FULL OUTER JOIN
-- 양쪽 테이블 레코드 전부를 짝이 없어도 출력
-- ORACLE SQL. (+) 방식으로는 불가
Select emp.first_name, emp.department_id,
dept.department_id, depte.department_name
from employees emp, departments dept
Where emp.department_id=dept.department_id;

--ANSI SQL
Select emp.first_name, emp.department_id,
dept.department_id, dept.department_name
from employees emp FULL OUTER JOIN departments dept
                    ON emp.department_id= dept.department_id;
-------------
-- SELF JOIN 
-- ----------
-- 자기 자신과 JOI
-- 자기 자신을 두 번 이상 호출하므로 -> ALias를 사용할 수밖에 없는JOIN
select* From employees;

--사원 정보, 매니저 이름을 함꼐 출력
-- 방법 1.
select emp.employee_id,
emp.first_name,
emp.manager_Id,
man.first_name,
man.employee_id
from employees emp JOIN employees man
                  On emp.manager_id= man.manager_id
  order by emp.employee_id;
  
  --방법2.
  select emp.employee_id,
  emp.first_name,
  emp.manager_id,
  man.employee_id,
  man.first_name
  from employees emp, employees man
  where emp.manager_id= man.employee_id(+)
  order by emp.employee_id;
  
  
  