# 2026-10-06 시연 데이터

오늘 추가한 모임 8개, 생성한 음식 사진 8개, 지도 추천 테스트 리뷰 6개를 보관합니다. 사진은 AI 생성 시연 이미지이며 실제 식당 사진이 아닙니다. 추천 리뷰의 5점 역시 실제 평가가 아닙니다.

- `src/main/resources/db/seed/community_meetups_demo.sql`: 기존 글을 덮어쓰지 않는 모임 추가 SQL.
- `src/main/resources/db/seed/community_meetup_photos.sql`: 작업 당시 로컬 모임 ID 7~14에 사진을 연결한 SQL. **다른 DB에서는 먼저 제목과 ID를 확인해야 합니다.**
- `scripts/seed_recommended_places_test.sql`: 카카오 공식 API로 확인한 서면 식당 6곳에 테스트 리뷰 추가. 동일 테스트 리뷰는 중복 생성하지 않습니다.
- `scripts/grant_demo_admin_20261006.sql`: 요청된 기존 계정 관리자 지정. 역할 컬럼이 있는 스키마가 필요합니다.
- `demo-assets/community/`: 생성한 모임 사진. 서버 실행 디렉터리의 `uploads/community/`로 복사해야 기존 이미지 URL에서 제공됩니다.

SQL은 수동 실행용이며 서버 실행 시 자동 적용되지 않습니다. 관리자·숨김 컬럼 등 기존 로컬 확장 스키마가 필요한 파일이 있습니다. GitHub 서버 코드와 확장된 로컬 코드가 다르므로, 이것만 푸시했다고 이전 신고·관리자 기능 전체가 반영되는 것은 아닙니다. 운영 DB 덤프와 비밀 설정은 포함하지 않습니다. DB 업데이트와 이미지 배치는 git push로 자동 배포되지 않습니다.
