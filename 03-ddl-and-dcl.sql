------------
-----dcl
----------------

-- create : 데이터베이스 객체 생성
-- alter: 데이터베이스 객체 수정
 -- drop : 데이터베이스 객체 삭제
 
 
 --system 계정으로 수행
 
 -- 사용자 생성: create user
 create user c##bituser identified by bituser;
 
 --sql plust 에서 사용자 접속
 -- 사용자 삭제 : drop user
 Drop user c##bituser cascade; -- CASCADE 연결된 모든 것을 함께 삭제
 
 --다시 생성
 create user c##bituser identified by bituser;
 
 
 --사용자 정보 확인
 -- user_: 현재 사용자 관련
 -- ALL_: 전체의 객체
 -- DBA_: DBA전용 , 객체의 모든 정보
 select* from User_users;
 select* from all_users;
 select* from DBA_users;
 
 --새로 만든 사용자 확인
 select* from DBA_USERS Where Username='c##bituser';
 
 --권한(privilege)과 역할(ROLO)
 --특정 작업 수행을 위해 적절한 권한을 가져야 한다.
 -- Create SESSION
 
 -- 시스템 권한의 부여: GRANT 권한 TO 사용자
 -- C##bituser에게 create session 권한을 부여
 GRANT create session To c##bituser;
 
 -- 일반적으로 connect, resource 롤을 부여하면 일반사용자의 역할 수행 가능
 GRANT connect, resource TO c##bituser
 
 -- ORECLE 12이후로부터는 임의로 tablespace 를 할당 해줘야 한다
 ALTER user c##bituser  --사용자 정보 수정
 default tablespace users --기본테이블 스페이스를  users에 저장
  QUOTA unlimited on users; --사용 용량 지정
  
  
-- 객체 권한 부여
-- C##BITUSER 사용자에게 HR.EMPLOYEES를 select 할 수 있는 권한 부여
GRANT select On HR.EMPLOYEES to C##BITUSER;
-- 객체 권한 회수
REVOKE select on Hr.EMPLOYEES from c##bituser;
Grant select ON HR.EMPLOYEES to c##bituser;
-- 전체 권한 부여시
-- GRANT ALL PRIVILEGES....

create user c##bituser identified by bituser;

-----------
-- ddl
-----------
-- 이후 C##bituser로 진행

--현재 내가 소유한 테이블 목록 확인
select*from tab;
-- 현재 나에게 주어진 role을 조회
select*from User_role_privs;

--create table: 테이블 생성
create table book (
     book_id number(5),
     title varchar2(50),
     author varchar2(10),
     pub_data Date default sysdate
);

select*from tab;
desc book;
--서브쿼리를 이용한 테이블 생성
--hr스키마의 employees 테이블의 일부 데이터를 추출, 새 테이블 생성

select * from hr.employees;

-- job_id 가 IT_관련 직원들만 뽑아내어 새 테이블 생성

create Table It_emps as(
 select*from hr.employees
 where job_id like 'IT_$'
 );
 
 desc IT_EMPS;
 
 -- author 테이블 추가
 create table author (
   author_id number(10),
   author_name varchar(50) not null,
   autohr_desc varchar2(500),
   primary key (author_id) -- 테이블 제약
   );
   
   desc author;
   
   ---- book 테이블의 author 컬럼 지우기
   ---나중에 author 테이블과 fk 연결
Desc book;
alter table book drop column author;

--- author 테이블 참조를 위한 컬럼 author_id 추가
alter table book 
add (author_id number(10));

--book 테이블의 book_id도 number (10)으로 변경

Alter table book modify (Book_id number(10));

desc book;

 