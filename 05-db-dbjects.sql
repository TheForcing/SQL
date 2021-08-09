-----------------
-- db objects
-------------

--view
--system 계정으로 수행
--------create view권한 필요

Grant create view to C##bituser;

--C##BITUSER 전환
--HR.employees 테이블로부터 department_id=10 사원의 view 생성
Create table emp_123
   as select * from HR.employees
       where department_id In (10,20,30);
    
--simple view 생성
Create OR REPLACE VIEW emp_20
    as select employee_id, first_name, last_name, salary
       from emp_123
       where department_id=20;
       
Desc emp_20;
-- 마치 일반 테이블 처럼 select 할 수 있다.

Select employee_id, first_name, salary From emp_20;

-- Simple view 는 제약 사항에 위배되지 않으면 내용 갱신 가능
UPDATE emp_20 set salary= salary*2;

Select first_name , salary from emp_123 where department_id=20;

-- 가급적 view 는 조회전용으로 사용하기를 권장
--with read only 옵션

create or replace view emp_10
   as select employee_id, first_name, last_name, salary
   from emp_123
   where department_id=10
   with read only;
   
select*from emp_10;

update emp_10 set salary= salary*2;

-- complex view
create or replace view book_detail
    (book_id, title, author_name, pub_date)
    as select book_id, title, author_name, pub_date
       from book b, author a
       where b.author_id=a.author+id;
select*from book_detail;
select*from author;

Desc book;
Insert into book (book_id,title, author_id)
values(1, '토지', 1);

Insert into book (book_id, title, author_id)
values( 2, '살인자의 기억법',2);

commit;

--complex view로 조회
select*from book_detail;

-- complex view 는 갱신이 불가
Update book_detail set author_name ='소설가'; --error

--view의 삭제
--book_deatil 은 book, author 테이블을 기반으로 함
drop view book_detail; -- view 삭제
Select*from tab;

--w view 확인을 위한 dictionary
select*from User_views;
select*from user_objects;

select object_name, object_type, status from user_objects
where object_type='view';


----- INDEX:검색 속도증가
--Insert , update, delete -> 인덱스의 갱싱 발생
--Hr.employess 테이블 복사->s_emp 테이블 생성
Create table s_emp
   As select*from HR.employees;
   
select*from S_emp;
--s_emp.employee_id에 Unique_index 부여
Create Unique Index s_emp_id
    on S_emp(employee_id);
-- Index 위한 dictionary
Select*from user_indexes;
Select*from user_ind_columns;
----인덱스 삭제
drop index s_emp_id;
Select*from user_indexes;
--인덱스는 테이블과 독립적: 인덱스 삭제해도 테이블 데이터는 남아있다.

    ---- SQUENCE
    --시퀀스 생성, 안젆하게 중복처리
    ROLLBACK;
    
    select Max(author_id) from author;
    create sequence seq_author_id
       start with 3
      INCREMENT by
      Maxvalue 1000000;
      
Insert Into author( author_id, author_name)
values(seq_author_id.maxtval)

select*from autohr;

--새 시퀀스 만들기
CREATE SEQUENCE my_seq
   start with 1
   INCREMENT 2
   MAXVALUE 10;
   
   --수도 컬럼 : CURRVAL(현재 시퀀스 값), NEXTVAL(값을 증가 새값)
select my_seq.NextVAL FROM dual;
select my_seq.CURRVAL FROm dual;

-- SEQUENCE를 위한 DICTIONARY
select*from user_SEQUENCECS;
select*from user_objects
where object_type='sequence';


