package com.tech.motjip.repository;

import com.tech.motjip.domain.ChatMessageRead;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import org.springframework.data.repository.query.Param;

import org.springframework.stereotype.Repository;

import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface ChatMessageReadRepository
        extends JpaRepository<ChatMessageRead, Long> {

    boolean existsByMessageIdAndMemberId(
            Long messageId,
            Long memberId
    );

    long countByMessageId(
            Long messageId
    );

    List<ChatMessageRead> findByMessageIdIn(
            List<Long> messageIds
    );

    List<ChatMessageRead> findByRoomIdAndMemberId(
            Long roomId,
            Long memberId
    );

    long countByMessageIdAndMemberIdNot(
            Long messageId,
            Long memberId
    );

    @Modifying
    @Transactional
    @Query(
            value = """
                    INSERT IGNORE INTO chat_message_reads
                    (message_id, room_id, member_id)
                    VALUES (:messageId, :roomId, :memberId)
                    """,
            nativeQuery = true
    )
    int insertIgnoreRead(
            @Param("messageId") Long messageId,
            @Param("roomId") Long roomId,
            @Param("memberId") Long memberId
    );
}