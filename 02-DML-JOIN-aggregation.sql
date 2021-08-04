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