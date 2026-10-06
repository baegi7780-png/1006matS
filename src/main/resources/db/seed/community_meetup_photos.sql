-- 시연용으로 추가한 8개 모임의 사진만 연결합니다.
SET NAMES utf8mb4;
START TRANSACTION;
UPDATE communities SET image_url = CASE com_id
  WHEN 7 THEN '/uploads/community/demo-meetup-gukbap.png'
  WHEN 8 THEN '/uploads/community/demo-meetup-pasta.png'
  WHEN 9 THEN '/uploads/community/demo-meetup-sushi.png'
  WHEN 10 THEN '/uploads/community/demo-meetup-chinese.png'
  WHEN 11 THEN '/uploads/community/demo-meetup-tteokbokki.png'
  WHEN 12 THEN '/uploads/community/demo-meetup-cafe.png'
  WHEN 13 THEN '/uploads/community/demo-meetup-bbq.png'
  WHEN 14 THEN '/uploads/community/demo-meetup-burger.png'
END
WHERE com_id BETWEEN 7 AND 14 AND content LIKE '%[시연용 모임 데이터]%';
COMMIT;
SELECT com_id, title, image_url FROM communities
WHERE com_id BETWEEN 7 AND 14 AND content LIKE '%[시연용 모임 데이터]%';
