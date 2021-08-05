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
dept.department_id, dept.department_name
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
  
  
  ---------------
  select emp.employee_id, 
  emp.first_name,
  emp.last_name,
  emp.department_id,
  dept.department_id
  from employees emp join departments dept
  ON emp.department_id= dept.department_id
  order by dept.department_id Desc, emp.employee_id;
  
  ----------------
  -- 집계 함수
  ------------
  -- 여러 레코드로부터 데이터를 수집, 하나의 결과 행을 반환한다.
  
  -- Count 함수: 갯수 세기
  Select count(*) From employees; -- 특정칼럼이 아닌 레코드의 갯수를 샌다
  
  Select count(commission_pct) from employees;-- 해당 컬럼이 null 이 아닌 갯수
  Select count(*) From employees
  Where commission_pct is not null;
  
  -- sum 함수 : 합계
  -- 급여의 합계
  Select Sum(salary) from employees;
  
  -- avg: 평균
  --급여의 평균
  Select avg(salary) from employees;
  
  -- avg 함수는 null 값은 집계에서 재외
  
  -- 사원들의 평균 커미션 비용
  Select avg(commission_pct) From employees;
  Select avg(nvl(commission_pct, 0))from employees;
  
  -- min/max ; 최소값, 최대값
  Select Max(salary), Min(salary), avg(salary), Median(salary)
  from employees;
  
  --일반적 오류
  Select department_id, Avg(salary)
  from employees; --Error
  
  --수정 : 집계함수
  Select department_id, avg(salary)
  from employees
  Group by department_id
  order by department_id;
  
  -- 집계 함수를 사용한 SELECT 문의 컬럼 목록에는
  --Group by에 참여한 필드, 집계 함수만 올수 있다.
  
  -- 부서별 평균 급여를 출력,
  -- 평균 급여가 7000 이상인 부서만 뽑아봅시다.
  Select department_id, Avg(salary)
  From employees
  Where Avg(salary) >= 7000
  Group by department_id; -- Error
  --집계 함수 실행 이전에 Where 절을 검사하기 때문에
  -- 집계 함수는 Where 절에서 사용할 수 없다.
  
  --집계 함수 실행 이후에 조건 검사하려면
  --Having 절을 이용
  
  Select department_id , Round(Avg(salary),2)
  from employees
  Group by department_id
     Having Avg(Salary) >= 7000
  Order by department_id;
  
  -----------
  -- 분석함수
  ----------
  -- ROLLUP
  --그룹핑된 결과에 대한 상세 요약을 제공하는 기능
  --일종의 ITEM TOTAL 기능을 수행
  Select department_id,
     job_id,
     Sum(salary)
From employees
Group by Rollup(department_id, Job_id);
  
  --cube 함수
  -- Cross table에 대한 Summary를 함꼐 추출
  --ROLLUP함수에서 추출되는 ITEM TOTAL과 함꼐
  -- Column TOTAL값을 함께 추출
  select department_id, Job_Id, Sum(salary)
  From employees
  Group by cube(department_id,job_id)
  Order by department_id;
  
  
  
-----------
--subquary
----------
-- 하나의 질의문 안에 다른 질의문을 포함하는 형태
--전체 사원 중, 급여의 중앙값보다 많이 받는 사원

--1. 급여의 중앙값?
Select median(salary) from employees;

--2.6200 보다 많이 받는 사원 쿼리
select first_name, salary from emloyees; where salary>6200;

--3. 두 쿼리를 합친다.
select first_name, salary from employees
where salary> (select Median(salary) from employees);

-- den 보다 늦게 입사한 사람들
--1. den 입사일 쿼리
select hire_date from employees where first_name='den';
-- 2. 특정 날짜 이후 입사한 살원 쿼리
select first_name,hire_date from employees where hire_date>='02/12/07';
--3. 두 쿼리를 합친다.
select hire_date from employees
where hire_date>=(where first_name='den' from employees(from employees where hire_date>='02/12/07'));

--다중행 서브 쿼리
--서브 쿼리의 결과 레코드가 둘 이상이 나올 때는 단일행 연사자를 사용할 수 없다.
--IN,ANY,ALL EXISTS 등 집합 연산자를 활용
select salary from employees where department_id=110;
select first_name, salary from employees
where salary = (select salary from employees where department_id=110); -error

--결과가 다중행이면 집합연산자를 활용
--salary= 12008 or salary= 8300
select first_name, salary from employees
where salary IN (select salary from employees where department_id=110); 

---ALl(and)
-- salary >12008 and salary >8300
select first_name, salary from employees
where salary >ALL (select salary from employees where department_id=110); 
--ANY(OR)
-- salary >12008 or salary >8300
select first_name, salary from employees
where salary >ANY (select salary from employees where department_id=110); 

-- 각 부서별로 최고 급여를 받는 사원을 출력
--1. 각 부서의 최고 급여 확인 쿼리
select department_id, Max(Salary) from employees
group by department_id;
--2.  서브쿼리의 결과 (department_id, max(Salary))
select department_id, employee_id, first_name, salary
from employees
where (department_id,salary) in(select department_id, Max(Salary) from employees 
group by department_id)
order by department_id;

-- 서브쿼리와 조인
select e.department_id, e.employee_id, e.first_name, e.salary
from employees e, (select department_id, max(salary) salary from employees
                      group by department_id) sal
where e.department_id= sal.department_id and 
 e.salary= sal.salary
 order by e.department_id;
 
 -- Correlated query
 -- 외부쿼리와 내부쿼리가 연관관계를 맺는 쿼리
 select e.department_id, e.employee_id, e.first_name, e.salary
 from employees e
 where e.salary =(select max(Salary) from employees
                        where department_id= e.department_id)
    order by e.department_id;
    
--TOP-K query
-- rowNUM: 레코드의 순서를 가리키는 가상의 컬럼(psuedo)
--2007년 입사자 중애서 급여 순위 5위까지 출력
  select rownum, first_name
  from (select * from employees
        where hire_date like '07%'
        order by salary desc)
where rownum <=5;

-- 집합 연산: ㄴet
-- union : 합집합, union all : 합집합 , 중복요소 체크 안함
-- intersect : 교집합
-- minus : 차집합
--05/01//01 이전 입사자 쿼리

select first_name, salary, hire_date from employees where hire_date<'05/01/01';
intersect --교집합
select first_name, salary, hire_date from employees where >12000

select first_name, salary, hire_date from employees where hire_date<'05/01/01';
minus -- 차집합
select first_name, salary, hire_date from employees where >12000;


----- 순위 함수
---- rank() : 중복 순위가 있으면 건너 뛴다, 
-- Dense_rank(): 중복순위 상관 없이 다음 순위
-- Row_number(): 순위 상관 없이 차례때로
select salary, first_name,
   rank() over (Order by salary desc) rank,
   Dense_rank() over (order by salary desc) dense_rank,
   Row_number() over (order by salary desc) row_number
from employees;

-- hierachical query: 계층적 쿼리
-- tree 형태의 구조 추출
-- level 가상 컬럼
select level, employee_id, first_name, manager_id
from employees
start with manager_id is null -- 트리 시작 조건
connect by prior employee_id = manager_id
order by level;