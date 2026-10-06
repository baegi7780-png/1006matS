-- 수동 실행용 모임 샘플. 기존 글은 수정하지 않으며 동일 제목은 중복 추가하지 않습니다.
SET NAMES utf8mb4;
START TRANSACTION;
CREATE TEMPORARY TABLE demo_meetups (
  tag_id BIGINT, title VARCHAR(200), content TEXT, place_name VARCHAR(100), days_ahead INT, hour_of_day INT
);
INSERT INTO demo_meetups VALUES
(1, '서면에서 따뜻한 돼지국밥 한 그릇 같이 먹어요', '서면에서 돼지국밥 먹으며 편하게 이야기할 분 구해요. 처음 참여하시는 분도 환영합니다! 각자 식사비를 부담하고 서면역에서 만나 식당을 함께 정해요. [시연용 모임 데이터]', '서면역 인근 돼지국밥집', 2, 19),
(3, '광안리에서 파스타 먹고 바다 산책해요', '광안리에서 파스타와 피자를 나눠 먹고 식사 후 바닷가를 산책하려고 해요. 메뉴와 식당은 참여자들과 상의해서 정해요. 편한 분위기로 함께해요! [시연용 모임 데이터]', '광안리 해수욕장 인근', 3, 18),
(4, '부산대 앞에서 초밥 저녁 모임 해요', '부산대 앞에서 초밥 좋아하는 분들과 저녁 먹어요. 혼자 오셔도 괜찮고 식사비는 각자 부담합니다. 부산대역에서 만나 이동해요. [시연용 모임 데이터]', '부산대역 인근 초밥집', 4, 19),
(2, '남포동에서 중식 나눠 먹을 분 구해요', '짜장면과 짬뽕, 탕수육을 함께 즐길 분 모집해요. 남포역에서 만나 식당으로 이동할 예정입니다. 함께 주문하는 메뉴 비용은 나눠서 부담해요. [시연용 모임 데이터]', '남포역 인근 중식당', 5, 18),
(5, '덕천에서 떡볶이와 분식 먹으러 가요', '덕천에서 떡볶이와 튀김 먹으며 가볍게 만나요. 매운 음식이 부담스러운 분도 함께 먹을 수 있도록 메뉴를 조율할게요. 처음 오시는 분도 환영합니다. [시연용 모임 데이터]', '덕천역 인근 분식집', 6, 18),
(6, '전포 카페거리에서 디저트 모임 해요', '전포 카페거리에서 커피와 디저트를 즐길 분 구해요. 좋아하는 카페와 디저트 이야기도 나누고 싶어요. 각자 주문한 메뉴 비용을 부담합니다. [시연용 모임 데이터]', '전포 카페거리', 7, 14),
(1, '해운대에서 고기 먹으며 주말 저녁 보내요', '해운대에서 고기 좋아하는 분들과 주말 저녁 모임 해요. 식당과 예산은 채팅으로 미리 상의하고 함께 주문한 메뉴는 나눠 계산합니다. [시연용 모임 데이터]', '해운대역 인근 고깃집', 8, 18),
(3, '동래에서 수제버거 점심 같이 먹어요', '동래에서 수제버거 먹으며 편하게 점심 함께할 분 구해요. 짧게 식사만 하고 가셔도 좋아요. 동래역에서 만나고 식사비는 각자 부담합니다. [시연용 모임 데이터]', '동래역 인근 수제버거집', 9, 12);
INSERT INTO communities (board_type_id, member_id, tag_id, title, content, region, place_name, meeting_at, is_deleted, is_hidden)
SELECT 1, m.member_id, d.tag_id, d.title, d.content, '부산', d.place_name,
       DATE_ADD(DATE_ADD(CURRENT_DATE(), INTERVAL d.days_ahead DAY), INTERVAL d.hour_of_day HOUR), 0, 0
FROM demo_meetups d
JOIN members m ON m.email_id = 'baegi7780@gmail.com'
WHERE NOT EXISTS (SELECT 1 FROM communities c WHERE c.title = d.title);
INSERT INTO community_members (com_id, member_id, role, status, hidden)
SELECT c.com_id, c.member_id, 'HOST', 'JOINED', 0
FROM communities c JOIN demo_meetups d ON c.title = d.title
WHERE c.content LIKE '%[시연용 모임 데이터]%'
AND NOT EXISTS (SELECT 1 FROM community_members cm WHERE cm.com_id = c.com_id AND cm.member_id = c.member_id);
COMMIT;
SELECT c.com_id, c.title, c.region, c.meeting_at, t.tag_name,
       (SELECT COUNT(*) FROM community_members cm WHERE cm.com_id = c.com_id AND cm.status = 'JOINED') AS participants
FROM communities c JOIN demo_meetups d ON c.title = d.title JOIN tags t ON t.tag_id = c.tag_id
ORDER BY c.com_id;
DROP TEMPORARY TABLE demo_meetups;
