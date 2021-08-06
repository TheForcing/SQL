-----------
--cud
-----------



--insert : 묵시적 방법
DESC author;
insert into author
values (1, '박경리', '토지 작가');

--- insert : 명시적 방법(컴럼 명시)
insert into author (author_id, author_name)
values( 2, '김명하');

--확인
select * from author;

-- DML은 트랜잭션의 대상
-- 취소: ROLLBACK
-- 변경사항 반영: commit
Rollback;
select*from author;

---- UPDATE
-- 기존 레코드의 내용 변경
UPDATE author
set author_desc='소설가';

select *from author;
rollback;
--update, delete 쿼리 작성시
--조건절을 부여하지 않으면 전체 레코드가 영향-> 주의
update author
set author_desc= '소설가'
where author_name='김영하';

select*from author;

commit; --- 변경사항 반영

update emp123
set salary = salary + salary *0.1
where department_id =30;

commit;
--delete : 테이블에서 레코드 삭제
select*from emp123;
--job_id가 MK_사원들 삭제
Delete from emp123
where job_id like 'MK_%';

--현재 급여  평균보다 높은 사람을 모두 삭제

delete from emp123
where salary >(select avg(Salary) from emp123);
commit;

select*from emp123

--TRUNCATE와 delete
-- delete 는 roll back 의 대상
--truncate 는 ROllback 의 대상이 아님
Delete From emp123;
select*from emp123;
RollBACK;
select= from emp123;

TRUNCATE TABLE emp123;

ROLLBACK; 