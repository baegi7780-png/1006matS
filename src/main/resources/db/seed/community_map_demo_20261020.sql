-- Local presentation fixture: 12 meetups and 12 map recommendation reviews.
-- Photos are AI-generated examples, NOT photos of the named restaurants.
-- Place IDs/coordinates: Kakao Local keyword API, checked 2026-10-20.
-- All reviews are explicitly fictional. Existing rows and ratings are unchanged.
-- Run against the application's local database after copying demo-assets/community.
-- Re-running this file does not duplicate this fixture.
USE motjip_db;
SET NAMES utf8mb4;
SET time_zone = '+09:00';
START TRANSACTION;
CREATE TEMPORARY TABLE demo_places_20261020 (
    place_id BIGINT PRIMARY KEY, place_name VARCHAR(100), address VARCHAR(100),
    latitude DECIMAL(10,8), longitude DECIMAL(11,8), tag_name VARCHAR(30),
    title VARCHAR(100), image_name VARCHAR(100), days_ahead INT, hour_of_day INT
);
INSERT INTO demo_places_20261020 VALUES
(14825645,'더도이종가집돼지국밥 본점','부산 북구 의성로 91',35.21250864,129.01069663,'한식','덕천 따뜻한 국밥 저녁 모임','gukbap',1,19),
(1767172489,'세로','부산 북구 덕천2길 89',35.21015813,129.01006220,'양식','덕천 파스타 같이 먹어요','pasta',2,18),
(11939328,'갓파스시 덕천점','부산 북구 금곡대로 11',35.21094766,129.00462226,'일식','덕천 초밥 저녁 함께해요','sushi',3,19),
(11358179,'신전떡볶이 덕천점','부산 북구 만덕대로 165',35.21344592,129.02280612,'분식','덕천 떡볶이 번개 모임','tteokbokki',4,18),
(11607963,'마비스커피','부산 북구 만덕대로 42',35.21095430,129.00965579,'카페','덕천 커피와 디저트 모임','cafe',5,14),
(7856441,'롯데리아 부산덕천점','부산 북구 만덕대로16번길 19',35.20957935,129.00736109,'양식','덕천 버거로 가볍게 점심','burger',6,12),
(1993299231,'영진돼지국밥 화명점','부산 북구 학사로 132',35.23433019,129.00826196,'한식','화명 국밥 한 그릇 같이해요','gukbap',7,19),
(18322383,'파스타바니타 화명점','부산 북구 금곡대로285번길 5',35.23361900,129.01320671,'양식','화명 파스타 저녁 모임','pasta',8,18),
(27482838,'스시투어 화명점','부산 북구 용당로16번길 23',35.23294504,129.00859136,'일식','화명 초밥 먹으러 가요','sushi',9,19),
(17546222,'취밍','부산 북구 금곡대로285번길 16',35.23406645,129.01252801,'중식','화명 중식 함께 먹어요','chinese',10,18),
(618556365,'일품대패 화명점','부산 북구 양달로 76',35.24400112,129.02148444,'한식','화명 고기 먹으며 이야기해요','bbq',11,19),
(775436905,'롯데리아 부산남산정역점','부산 북구 만덕3로 21',35.21220769,129.02636380,'양식','남산정역 버거 점심 모임','burger',12,12);

-- Use an existing administrator as host; do not create or modify real accounts.
SET @demo_host_20261020 = (
    SELECT MIN(member_id) FROM members
    WHERE role IN ('ADMIN','ROLE_ADMIN')
      AND (suspended_until IS NULL OR suspended_until < NOW())
);
-- Missing host or tags aborts before any permanent inserts.
CREATE TEMPORARY TABLE demo_guard_20261020 (ok INT NOT NULL);
INSERT INTO demo_guard_20261020 SELECT IF(
    @demo_host_20261020 IS NOT NULL AND
    (SELECT COUNT(*) FROM demo_places_20261020 d JOIN tags t ON t.tag_name=d.tag_name)=12,
    1, NULL);

INSERT INTO communities
    (board_type_id, member_id, tag_id, title, content, region, place_name,
     place_lat, place_lng, meeting_at, image_url, is_deleted, is_hidden)
SELECT 1, @demo_host_20261020, t.tag_id, d.title,
    CONCAT('[DEMO_MAP_MEETUPS_20261020] 발표용 가상 모임입니다. 실제 모집이 아닙니다. ',
           d.place_name,'에서 함께 식사하는 상황을 시연합니다. 식사비는 각자 부담하고 시간은 채팅으로 조율합니다. ',
           '첨부 사진은 AI 생성 예시이며 해당 식당의 실제 사진이 아닙니다.'),
    '부산', CONCAT(d.place_name,' · ',d.address), d.latitude, d.longitude,
    DATE_ADD(DATE_ADD(CURRENT_DATE(),INTERVAL d.days_ahead DAY),INTERVAL d.hour_of_day HOUR),
    CONCAT('/uploads/community/demo-meetup-',d.image_name,'.png'),0,0
FROM demo_places_20261020 d JOIN tags t ON t.tag_name=d.tag_name
WHERE NOT EXISTS (
    SELECT 1 FROM communities c WHERE c.title=d.title
    AND c.content LIKE '[DEMO_MAP_MEETUPS_20261020]%'
);

INSERT INTO community_members (com_id,member_id,role,status,hidden)
SELECT c.com_id,c.member_id,'HOST','JOINED',0
FROM communities c JOIN demo_places_20261020 d ON c.title=d.title
WHERE c.content LIKE '[DEMO_MAP_MEETUPS_20261020]%'
AND NOT EXISTS (
    SELECT 1 FROM community_members cm WHERE cm.com_id=c.com_id AND cm.member_id=c.member_id
);

-- Existing recommendation logic requires average >= 4.5 and a 5-star review.
-- New places have no real reviews in the checked local database.
INSERT INTO reviews
    (place_id,place_name,latitude,longitude,member_id,rating,revisit,content,tags,image_url,is_hidden)
SELECT d.place_id,d.place_name,d.latitude,d.longitude,@demo_host_20261020,5,1,
    '[DEMO_MAP_REVIEWS_20261020] 지도 추천 표시용 가상 리뷰입니다. 실제 방문 후기나 실제 평점이 아닙니다. 사진은 AI 생성 예시이며 해당 식당의 실제 사진이 아닙니다.',
    '시연용,가상리뷰,AI생성사진',CONCAT('/uploads/community/demo-meetup-',d.image_name,'.png'),0
FROM demo_places_20261020 d
WHERE NOT EXISTS (
    SELECT 1 FROM reviews r WHERE r.place_id=d.place_id
    AND r.content LIKE '[DEMO_MAP_REVIEWS_20261020]%'
);
COMMIT;

SELECT COUNT(*) AS demo_meetups,COUNT(DISTINCT image_url) AS distinct_photo_examples
FROM communities WHERE content LIKE '[DEMO_MAP_MEETUPS_20261020]%';
SELECT COUNT(*) AS demo_reviews FROM reviews WHERE content LIKE '[DEMO_MAP_REVIEWS_20261020]%';
SELECT d.place_id,d.place_name,AVG(r.rating) AS average_rating,
       MIN(r.latitude) AS latitude,MIN(r.longitude) AS longitude
FROM demo_places_20261020 d JOIN reviews r ON r.place_id=d.place_id
GROUP BY d.place_id,d.place_name ORDER BY d.place_id;
DROP TEMPORARY TABLE demo_guard_20261020;
DROP TEMPORARY TABLE demo_places_20261020;
