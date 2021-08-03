--DML: SELECT



----------------
--SELECT ~ FROM
-----------------

-- 전체 데이터의 모든 컬럼 조회
-- 컬럼의 출력 순서는 정의에 따른다
sELECT * FROM employees;
SELECT * FROM departments;

-- 특정 컬럼만 선별 projection 
-- 사원의 이름, 입사일, 급여 출력
select first_name,
    hire_date,
    salary
FROM employees;

--산술연산: 기본적인 산술연산 가능
-- dual: 오라클의 가상의 테이블 
-- 특정 테이블의 속한 데이터가 아닌
-- 오라클 시스템에서 값을 구한다.

select 10*10 * 3.14159 FROM dual;
--결과 1개
SELECT 10*10 * 3.14159 FROM employees;
-- 결과 테이블의 레코드 수만큼

--select first_name, job_id *12
--from employees; -- error : 수치데이터 아니면 산출연산 오류
--dsec employees;


--select first_name + ' '+ last_name
--from employees; -- ERROR: first_name , last_name 은 문자열

--문자열 연결은 ||로 연결
Select first_name || '' || last_name
from employees;

-- NULL
SELECT first_name, salary, salary*12
From employees;

SELECT first_name, salary, commission_pct
FROM employees;

SELECT first_name, salary, commission_pct,
salary + salary * commission_pct
From employess;  -- NULL이 포함한 산술식은 NULL

--NVL:
SELECT first_name,
      salary.
      commission_pct,
      salary + salary * NVL(commission_pct,0)
FROM employees;

-- ALIAS: 별칭
SELECT
  first_name || ' '|| last,time,
  phone_number as 전화번호,
  salary "급 여" -- 공백 문자,, 특수문자 ""표시사용
FROM employees;

SELECT first_name ||' '|| last_name 이름,
hire_date as 입사일,
phone_number "전화번호",
salary 급여, salary*12 as 연봉
FROM employees;

----------------
-----Where-----
-------비교연산
-- 급여가 15000이상인 사원의 목록
SELECT first_name, salary
From employees;
Where salary >= 15000;

--날짜도 대소비교 가능
--입사일 07/01/01 이후인 사원의 목록
Select first_name, hire_date
From employees
Where hire_date >= '07/01/01';
--이름이 Lex인 사원의 이름, 급여, 입사일 출력

Select first_name, salary, hire_date
From employees
Where first_name = 'Lex';

--논리 연산자
-- 급여가 14000 이하이거나 17000이상인  사원의 목록
Select first_name, salary
From employees
Where salary <= 14000 or salary>=17000; 
  
--급여가 14000 이상, 17000이하인 사원의 목록
Select firsy_name, salary
From employees
Where salary >= 14000 and salary <=17000;

-- BETWEEN
Select first_name, salary
From employees
where salary Between 14000 and 17000;

--널체크
-- = NULL, != null은 하면 안됨
-- 반드시 is Null, is NOt NULL 사용
--커미션을 받지 않는 사람의 목록
Select first_name, commission_pct
From employees
Where commission_pct is NULL;

Select first_name, department_id
From employees
Where  department_id = 10 or 
 department_id= 20 or
 department_id=30;
 
 --IN
 Select first_name, department_id
 From employees
 where department_id IN (10, 20, 30);
 
 -- ANY
 Select first_name, department_id
 From employees
 Where department_id= Any (10, 20, 30);
 
 -- ALL: 뒤에 나오는 집합 전부를 만족
 Select first_name, salary
 From employees
 Where salary> ALL (12000, 17000);
 
 --Like 연산자 : 부분 검색
 --%: 0글자 이상의 정해지지 않은 문자열
 --_: 1글자(고정) 정해지지 않은 문자열
 -- 이름에 am을 포함한 사원의 이름과 급여를  출력
 
 Select first_name , salary
 From employees
 Where first_name Like '%am%';
 
--연습:
-- 이름의 두번째 글자가 a인 사원의 이름과 연봉
Select first_name, salary
From employees
Where first_name Like '_a_';

--ORDER BY:정렬
--오름차순:작은 값-> 큰값 ASC(defauly)
--내림차순: 큰값->작은값 DESC

--부서번호 오름차순 -> 부서번호, 급여, 이름
Select department_id,
 salary, first_name
 From employees
 Order By department_id; --오름차순 정렬
 -- 급여 10000이상 직원
 -- 정렬: 급여 내림차순
 Select first_name, salary
 FROM employees 
 Where salary >= 10000
 Order By salary Desc; 
 
 -- 출력: 부서 번호, 급여, 이름
 -- 정렬: 1차정렬 부서번호 오름차순, 2차정렬 급여내림차순
 Select dapartment_id, salary, first_name
 From employees
 Order By department_id, --1차 정렬
    salary Desc; -- 2ㅣ 정렬
    
    ----------
    --단일행 함수
    --한개의 레코드를 입력으로 받는 함수
    -- 문자열 단일행 함수 연습
Select first_name, last_name,
  CONCAT(First_name, Concat(' ', last_name)), --연결
 INITCAP(first_name || ' ' || last_name), -- 각 단어의 첫글자만 대문자
  Lower(first_name),
  Upper(first_name),
  LPAD(first_name, 10, '*'),    --왼쪽채우기
  RPAD(first_name, 10, '*')    -- 오른쪽 채우기
  
From employees;
  Select Ltrim('  Oracle    '), --왼쪽 공백 제거
     Rtrim( '    Oracle    '), -- 오른쪽 공백 제거
     Trim( '*' From '*****Database*****'), --양쪽의 *제거
     Substr( 'Oracle Database', 8, 4), --부분 문자열
     Substr( 'Oracle Database', -8, 8) --부분 문자열
From dual;

--- 수치형 단일행 함수
Select Abs(-3.14), --- 절대값
 Ceil(3.14),  -- 소수점 올림(천정)
 Floor(3.14), -- 소수점 버림(바닥)
 MOD(7,3), --나머지
 Power(2, 4), -- 제곱: 2의 4제곱
 ROUND(3.5),  -- 소수점 반올림
 ROUND(3.14159, 3), -- 소수점 세번째 자리까지 반올림
 TRUNC(3.5),    -- 소수점 버림
 TRUNC(3.14159, 3), -- 소수점 세번째까지 버림
 SIGN(-10)  --부호 혹은 0
 FROM dual;
 
 
 -------------
 -- Date FORMAT
 -----------
 -- 현재 날짜와 시간
 Select SYSDATE FROM dual; --1행
 Select SYSDATE FROM employees; -- employees의 레코드 개수만큼
 
 --날짜 관련 단일행 함수
 Select sysdate,
   ADD_Months(sysdate, 2), -- 2개월 후
   Last_day(sysdate), --- 이번 달의 마지막 날
   MONTHS_BETWEEN(sysdate, '99/12/31'), -- 1999년 마지막날 이후 몇 달이 지났나
   NEXTDAY(sysdate, 7), 
    Round(sysdate, 'MONTH'),
   Round(sysdate, 'YEAR'),
   TRUNC(sysdate, 'MONTH'),
   TRUNC(sysdate, 'YEAR')
  
From dual;


----------
-- 변환 함수
----------

-- TO_NUMBER(s, fmt) : 문자열을 포맷에 맞게 수치형으로 변환
-- TO_DATE(s, fmt) : 문자열을 포맷에 맞게 날짜형으로 변환
-- TO-CHAR(o, fmt) : 숫자 or 날짜를 포맷에 맞게 문자열으로 변환

--To_CHAR
SELECT first_name, hire_date,
  TO_CHAR(hire_date, 'YYYY-MM-DD'),
  TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS')
FROM employees;

Select TO_CHAR(3000000, 'L999,999,999') FROM dual;

Select first_name, To_Char(Salary * 12, '$999,999.00') SAL
From employees;

-- TO_NUMBER: 문자형 -> 숫자형
Select TO_NUMBER('2021'),
  TO_NUMBER('$1,450.13', '$999,999.99')
From dual;

-- TO_DATE: 문자형 -> 날짜형
Select to_date('1999-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS')
From dual;

-- 날짜 연산 
-- Date +(-) Number: 날짜에 일수 더하기(뻬기)
-- Date - Date ; 두 date사이의 차이 일 수
-- Date +(-) Number/ 24: 날짜에 시간 더하기
SELECT TO_CHAR(Sysdate, 'YY/MM/DD HH24:MI'),
  Sysdate + 1, -- 1일 뒤 
  Sysdate - 1, -- 1일 전
  Sysdate - To_DATE('19991213'),
  TO_CHAR(Sysdate + 13/24, 'YY/MM/DD HH24:MI') -- 13시간 후
From dual;

-----------
--NULL 관련
------------

--nvl함수
Select first_name,
salary, 
commission_pct,
salary * nvl(commission_pct,0) commission
From employees;

-- NVL2 함수
Select first_name,
salary,
commission_pct,
nvl2(commission_pct, salary * commission_pct, 0) commission
From employees;

--case 함수
-- AD관련 직원에게는 20%, SA관련 직원 10%, 
-- IT관련 직원에게는 8%, 나머지는 5% 지급
Select first_name, job_id, SubStr(job_id, 1,2),
   Case SubStr(job_id, 1, 2) When 'AD' Then salary* 0.2
                        When 'SA' THEN salary * 0.1
                        When 'IT' THEN salary * 0.08
                        Else salary * 0.05
    END bonus
From employees;

--Decode 함수
Select first_name, job_id, salary, Substr(job_id, 1,2),
 Decode(substr(job, 1,2),
      'AD', salary* 0.2,
      'SA', salary* 0.1,
      'IT', salary* 0.08,
      salary*0.05) -- else
      bonus
    From employees;
    
    --연습문제:
    -- 직원의 이름, 부서, 팀을 출력
    --팀
     -- 부서코드:10~30 ->A-Group
     -- 부서코드 : 40~50->B-Group
     -- 부서코드 : 60~100 -> C-Group
     -- 나머지: Remainder
     

     
 