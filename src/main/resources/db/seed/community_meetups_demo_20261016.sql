-- 사진 포함 시연용 모임 5개. 기존 글/사진/참여자를 변경하지 않습니다.
-- 사전 조건: 확장 스키마, 기존 작성자 계정, demo-assets의 사진이 uploads/community에 있어야 합니다.
-- 같은 표시와 제목의 모임이 있으면 재실행해도 중복 추가하지 않습니다.
USE motjip_db;
SET NAMES utf8mb4;
SET time_zone = '+09:00';
START TRANSACTION;
CREATE TEMPORARY TABLE demo_meetups_20261016 (
    tag_id BIGINT, title VARCHAR(200), content TEXT, place_name VARCHAR(100),
    days_ahead INT, hour_of_day INT, image_url VARCHAR(500)
);
INSERT INTO demo_meetups_20261016 VALUES
(1, '서면 국밥 저녁 같이 먹어요', '서면역에서 만나 따뜻한 돼지국밥 한 그릇 먹어요. 처음 오시는 분도 환영하며 식사비는 각자 부담합니다. 식당은 참여자와 채팅으로 정해요. [DEMO_MEETUPS_20261016] 시연용 가상 모임이며 실제 모집이 아닙니다.', '서면역 인근', 1, 19, '/uploads/community/demo-meetup-gukbap.png'),
(3, '광안리 파스타 모임', '광안리에서 파스타를 먹고 바다 산책도 함께해요. 함께 주문한 메뉴는 나눠 계산하고 예산은 미리 상의합니다. [DEMO_MEETUPS_20261016] 시연용 가상 모임이며 실제 모집이 아닙니다.', '광안리 해수욕장 인근', 2, 18, '/uploads/community/demo-meetup-pasta.png'),
(4, '부산대 초밥 먹으러 가요', '부산대역에서 만나 초밥으로 저녁 먹을 분 구해요. 혼자 참여해도 편하게 이야기할 수 있는 소규모 식사 모임입니다. 각자 주문한 식사비를 부담해요. [DEMO_MEETUPS_20261016] 시연용 가상 모임이며 실제 모집이 아닙니다.', '부산대역 인근', 3, 19, '/uploads/community/demo-meetup-sushi.png'),
(5, '덕천 떡볶이 번개 모임', '덕천역 근처에서 떡볶이와 튀김을 함께 먹어요. 매운 정도는 참여자와 상의하고 함께 주문한 메뉴 비용은 나눠 부담합니다. [DEMO_MEETUPS_20261016] 시연용 가상 모임이며 실제 모집이 아닙니다.', '덕천역 인근', 4, 18, '/uploads/community/demo-meetup-tteokbokki.png'),
(6, '전포 카페에서 디저트 모임', '전포 카페거리에서 커피와 디저트를 즐기며 가볍게 이야기해요. 카페는 채팅으로 정하고 음료와 디저트는 각자 주문합니다. [DEMO_MEETUPS_20261016] 시연용 가상 모임이며 실제 모집이 아닙니다.', '전포 카페거리', 5, 14, '/uploads/community/demo-meetup-cafe.png');

SET @demo_before_count = (SELECT COUNT(*) FROM communities);
INSERT INTO communities
    (board_type_id, member_id, tag_id, title, content, region, place_name, meeting_at, image_url, is_deleted, is_hidden)
SELECT 1, m.member_id, d.tag_id, d.title, d.content, '부산', d.place_name,
       DATE_ADD(DATE_ADD(CURRENT_DATE(), INTERVAL d.days_ahead DAY), INTERVAL d.hour_of_day HOUR),
       d.image_url, 0, 0
FROM demo_meetups_20261016 d
JOIN members m ON m.member_id = (
    SELECT MIN(member_id) FROM members WHERE email_id = 'baegi7780@gmail.com'
)
WHERE NOT EXISTS (
    SELECT 1 FROM communities c
    WHERE c.title = d.title AND c.content LIKE '%[DEMO_MEETUPS_20261016]%'
);
INSERT INTO community_members (com_id, member_id, role, status, hidden)
SELECT c.com_id, c.member_id, 'HOST', 'JOINED', 0
FROM communities c
JOIN demo_meetups_20261016 d ON c.title = d.title
WHERE c.content LIKE '%[DEMO_MEETUPS_20261016]%'
  AND NOT EXISTS (
      SELECT 1 FROM community_members cm WHERE cm.com_id = c.com_id AND cm.member_id = c.member_id
  );
COMMIT;

SELECT COUNT(*) - @demo_before_count AS newly_added_posts FROM communities;
SELECT c.com_id, c.title, t.tag_name, c.meeting_at, c.image_url,
       (SELECT COUNT(*) FROM community_members cm WHERE cm.com_id = c.com_id AND cm.status = 'JOINED') AS participants
FROM communities c
JOIN tags t ON t.tag_id = c.tag_id
WHERE c.content LIKE '%[DEMO_MEETUPS_20261016]%'
ORDER BY c.com_id;
DROP TEMPORARY TABLE demo_meetups_20261016;
