-- 사용자가 요청한 기존 계정의 관리자 지정 재현용입니다.
-- 계정을 생성하지 않습니다. 실행 전 대상 계정과 현재 DB를 확인하세요.
-- members.role 컬럼이 있는 확장 스키마에서만 사용합니다.
USE motjip_db;
SET NAMES utf8mb4;
START TRANSACTION;
UPDATE members SET role = 'ADMIN' WHERE email_id = 'grand4870@gmail.com';
COMMIT;
SELECT member_id, email_id, role FROM members WHERE email_id = 'grand4870@gmail.com';
