<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WEIVER - 커뮤니티 페이지</title>

    <!--js-->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"
        integrity="sha384-fbbOQedDUMZZ5KreZpsbe1LCZPVmfTnH7ois6mU1QK+m14rQ1l2bGBq41eYeM/fS"
        crossorigin="anonymous"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    <!--css 연결-->
    <link rel="stylesheet" href="../css/community.css">
    <link rel="stylesheet" href="../css/musical.css">
    <link rel="stylesheet" href="../css/public.css">
    
<script>

$(function() {
    // 댓글 수정 버튼 클릭 이벤트
    $('.commentEditBtn').click(function() {
        var commentId = $(this).closest('.commentAndBtn').data('comment-id');
        var txt = $('#commentContent_' + commentId).text();
        $('#commentContent_' + commentId).html(
            "<textarea rows='3' cols='30' id='textarea1_"+commentId+"' style='width: 620px; height: 40px; background-color: #586A85; margin-top: 15px'>"+txt+"</textarea>"
        );
    });

 	// 대댓글 수정 버튼 클릭 이벤트
    $('.recommentEditBtn').click(function() {
        var recommentId = $(this).closest('.recommentWrap').data('recomment-id');
        var txt = $('#recommentContent_' + recommentId).text();
        $('#recommentContent_' + recommentId).html(
            "<textarea rows='3' cols='30' id='textarea2_"+recommentId+"' style='width: 450px; height: 40px; background-color: #586A85; margin-top: 15px'>"+txt+"</textarea>"
        );
    });

    // 댓글 포커스 아웃(blur) 이벤트
    $(document).on('blur', 'textarea[id^="textarea1_"]', function() {
        var commentId = $(this).attr('id').split('_')[1];
        var editedContent = $(this).val();
        // 편집 작동되는지 콘솔로그로 확인
        console.log('Edited content for comment ' + commentId + ': ' + editedContent);

        // AJAX로 댓글 업데이트 컨트롤러 실행하기
        $.ajax({
            url: '/community/update/reply/' + commentId,
            type: 'POST',
            data: {
                id: commentId,
                content: editedContent
            },
            success: function(response) {
                // 작동 성공
                $('#commentContent_' + commentId).html(editedContent);
            },
            error: function(xhr) {
                // 작동 실패
                console.error('Error updating comment:', xhr.responseText);
            }
        });
    });

    // 대댓글 포커스 아웃(blur) 이벤트
    $(document).on('blur', 'textarea[id^="textarea2_"]', function() {
        var recommentId = $(this).attr('id').split('_')[1];
        var editedContent = $(this).val();
        // 편집 작동되는지 콘솔로그로 확인
        console.log('Edited content for recomment ' + recommentId + ': ' + editedContent);

        // AJAX로 대댓글 업데이트 컨트롤러 실행하기
        $.ajax({
            url: '/community/update/rereply/' + recommentId,
            type: 'POST',
            data: {
                id: recommentId,
                content: editedContent
            },
            success: function(response) {
                // 작동 성공
                $('#recommentContent_' + recommentId).html(editedContent);
            },
            error: function(xhr) {
                // 작동 실패
                console.error('Error updating recomment:', xhr.responseText);
            }
        });
    });
});

//게시글 삭제 함수
function deletePost(postsId) {
    // 삭제를 확인하는 다이얼로그를 띄우기
    const isConfirmed = confirm("글을 삭제하시겠습니까?");
    if (!isConfirmed) {
        return; // 삭제 취소
    }

    // AJAX로 댓글 삭제 컨트롤러 실행하기
    $.ajax({
        url: '/community/delete/post/' + postsId,
        type: 'DELETE',
        success: function(response) {
            console.log('글이 삭제되었습니다.');
            window.location.href = 'http://localhost:8081/community';
        },
        error: function(xhr) {
            // 작동 실패
            console.error('댓글 삭제 실패:', xhr.responseText);
        }
    });
}

//댓글 삭제 함수
function deleteReply(commentId) {
    // 삭제를 확인하는 다이얼로그를 띄우기
    const isConfirmed = confirm("댓글을 삭제하시겠습니까?");
    if (!isConfirmed) {
        return; // 삭제 취소
    }

    // AJAX로 댓글 삭제 컨트롤러 실행하기
    $.ajax({
        url: '/community/delete/reply/' + commentId,
        type: 'DELETE',
        success: function(response) {
            console.log('댓글이 삭제되었습니다.');
            // 댓글 삭제 성공 시 페이지 새로고침
            location.reload();
        },
        error: function(xhr) {
            // 작동 실패
            console.error('댓글 삭제 실패:', xhr.responseText);
        }
    });
}

//대댓글 삭제 함수
function deleteRereply(recommentId) {
    const isConfirmed = confirm("대댓글을 삭제하시겠습니까?");
    if (!isConfirmed) {
        return; // 삭제 취소
    }

    $.ajax({
        url: '/community/delete/rereply/' + recommentId,
        type: 'DELETE',
        success: function(response) {
            console.log('대댓글이 삭제되었습니다.');
            location.reload(); // 대댓글 삭제 성공 시 페이지 새로고침
        },
        error: function(xhr) {
            console.error('대댓글 삭제 실패:', xhr.responseText);
            location.reload();
        }
    });
}

function changeHeartIcon(type, id, heartIcon) {
    // 서버로 보낼 데이터 준비
    const data = {
        type: type, // 'post', 'reply', 'rereply' 중 하나
        id: id // 게시글, 댓글 또는 대댓글의 ID 값
    };

    // 서버에 데이터 전송 (AJAX 사용)
    $.ajax({
        type: 'POST',
        url: '/community/insert/postlike/' + id, // 좋아요 처리를 담당하는 컨트롤러 URL
        contentType: 'application/json',
        data: JSON.stringify(data),
        success: function (response) {
            // 서버에서 응답을 받으면 좋아요 개수를 업데이트
            const likesCount = response.likesCount;
            $(heartIcon).next().text(likesCount);
        },
        error: function (error) {
            // 에러 처리
            console.error('Error occurred:', error);
        }
    });
}
</script>



</head>

<body>
    <!-- 전체 컨테이너 -->
    <div class="backgroudBox">
        <!-- 헤더 -->
        <header>
            <img src="../img/logo.png" alt="logo" height="70" width="300" />
        </header>

        <!-- 뒤로가기 버튼 -->
        <div class="backBtn">
            <a href="/community">
                <i class="bi-chevron-left"></i>
            </a>
        </div>

        <!-- 게시글 컨테이너 -->
        <div class="postWrap">
            <!-- 게시글 헤더 (작성, 제목, 공유하기 버튼) -->
            <div class="postHeader">
                <h2>${posts.title}</h2>
                <i class="bi bi-reply-fill"></i>
            </div>
            <hr>

            <!-- 게시글 작성자 -->
            <div class="postWriter">${posts.user.nickname}</div>
            <hr>

            <!-- 연결된 작품 -->
            <c:if test="${posts.type eq 'Review'}">
                <div class="currentMusical">
                    <img src="/img/poster.jpg" alt="X">
                    <div class="currentMusicalInfo">
                        <div class="musicalTitle">웃는 남자</div>
                        <div class="musicalPeriod">2022-06-10~2012-08-22</div>
                    </div>
                </div>
                <hr>
            </c:if>

            <!-- 게시글 내용 (텍스트, 이미지) -->
            <div class="postContent">${posts.content}</div>
            <img class="postImg" src="${posts.images}" alt="게시글 이미지">

            <!-- 조회, 댓글, 좋아요 아이콘 그룹 -->
            <div class="iconGroup">
                <div>
                    <i class="bi-eye"></i>
                    <span>${posts.viewed}</span>
                </div>
                <div>
                    <i class="bi-chat"></i>
                    <span>${posts.viewed}</span>
                </div>
                <div>
				    <i class="bi-suit-heart" onclick="changeHeartIcon('post', ${post.id}, this)"></i>
				    <span>${post.postlikes.size()}</span>
				</div>
            </div>
        </div>

        <!-- 게시글 수정하기, 삭제하기 버튼 -->
        <div class="postBtnGroup">
                <input type="submit" value="수정하기" class="postModifyBtn" onclick="location.href='/community/update/${posts.id}'">
                <input type="submit" value="삭제하기" class="postDeleteBtn" onclick="deletePost(${posts.id})">
        </div>

        <!-- 댓글 컨테이너 -->
        <div class="commentWrap">
            <!-- 총 댓글 수 조회 -->
            <div class="totalComment">총 댓글 수 : <span>${posts.viewed}</span></div>

            <!-- 작성된 댓글 (아이디, 댓글, 좋아요 아이콘, 대댓글 링크, 버튼) -->
            <hr>
            <c:forEach var="reply" items="${reply}">
                <div class="commentAndBtn" data-comment-id="${reply.id}">
		        <div class="commentIDAndContent">
		            <div class="commentID">${reply.user.nickname}</div>
		            <div class="commentContent" id="commentContent_${reply.id}">${reply.content}</div>
		            <div class="likeAndRecomment">
		                <i class="bi-suit-heart" onclick="changeHeartIcon('reply', ${reply.id}, this)"></i>
		                <span>${reply.id}</span>
		                <a href="/community/${posts.id}/reply/${reply.id}" style="text-decoration: none;">
		                    <span class="recommentBtn">대댓글</span>
		                </a>
                        </div>
                    </div>

                    <!-- 댓글 수정, 삭제 버튼 -->
                    <div class="commentBtnGroup">
                        <button class="commentEditBtn">수정</button>
                        <button onclick="deleteReply(${reply.id})">삭제</button>
                    </div>
                </div>

                <!-- 대댓글 컨테이너 -->
                <c:forEach var="rereply" items="${rereply}">
                    <c:if test="${rereply.reply.id == reply.id}">
                        <div class="recommentWrap" data-recomment-id="${rereply.id}">
                            <div class="recommentGroup">
                                <i class="bi-arrow-return-right"></i>
                                <div class="recommentInfo">
                                    <div class="recommentID">${rereply.user.nickname}</div>
                                    <div class="recommentContent" id="recommentContent_${rereply.id}">${rereply.content}</div>
                                    <div class="likeAndRecomment">
                                        <i class="bi-suit-heart" onclick="changeHeartIcon('rereply', ${rereply.id}, this)"></i>
                                        <span>${rerepliesForReply.size()}</span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="recommentBtnGroup">
                                <button type="button" class="recommentEditBtn">수정</button>
                                <button onclick="deleteRereply(${rereply.id})">삭제</button>
                            </div>
                            
                        </div>
                    </c:if>
                </c:forEach>
                <hr>
            </c:forEach>
        </div>

        <!-- 댓글 입력 창 -->
        <div class="commentInputGroup">
            <form action="" method="post">
                <input class="commentInput" type="text">
                <input class="commentInputBtn" type="submit" value="작성하기">
            </form>
        </div>

    </div>

    <footer>Copyright Weiver 2023 All Rights Reserved</footer>
    <nav>
        <a href="#"><i class="bi bi-house-door-fill"></i>
            <div>HOME</div>
        </a>
        <a href="/community"><i class="bi bi-chat-dots-fill"></i>
            <div>COMMUNITY</div>
        </a>
        <a href="#"><i class="bi bi-person-fill"></i>
            <div>MY PAGE</div>
        </a>
    </nav>
</body>



</html>