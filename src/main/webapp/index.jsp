<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: 'Batang', serif;
            background-color: #f2e6d9;
            color: #3c2415;
            margin: 0;
            padding: 0;
            background-repeat: repeat;
        }

        .scroll {
            max-width: 800px;
            margin: 40px auto;
            background-color: #f8f3e9;
            border: 2px solid #93785c;
            border-radius: 5px;
            padding: 20px 40px;
            box-shadow: 5px 5px 15px rgba(0, 0, 0, 0.2);
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #93785c;
            padding-bottom: 15px;
        }

        h1 {
            font-size: 2.2rem;
            color: #6b4423;
            letter-spacing: 2px;
            margin: 10px 0;
        }

        .subtitle {
            font-style: italic;
            margin-top: 5px;
        }

        .main-content {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .scholar-image {
            width: 150px;
            height: 150px;
            background-color: #e8d8c0;
            border: 1px solid #93785c;
            border-radius: 50%;
            margin-bottom: 20px;
            background-image: url('./assets/character.jpeg');
            background-size: cover;
            background-position: center;
        }

        .chat-area {
            width: 100%;
            padding: 20px;
            background-color: #f8f3e9;
            border: 1px solid #93785c;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .answer-scroll {
            background-color: #fff;
            border: 1px solid #d4b995;
            border-radius: 5px;
            padding: 15px;
            margin-top: 20px;
            font-size: 1rem;
            min-height: 100px;
            max-height: 200px;
            overflow-y: auto;
        }

        textarea {
            width: 100%;
            padding: 15px;
            border: 1px solid #93785c;
            border-radius: 5px;
            background-color: #fff;
            box-sizing: border-box;
            font-family: 'Batang', serif;
            font-size: 1rem;
            color: #3c2415;
            resize: none;
        }

        button {
            background-color: #6b4423;
            color: #f8f3e9;
            border: none;
            border-radius: 5px;
            padding: 10px 20px;
            font-family: 'Batang', serif;
            font-size: 1rem;
            margin-top: 10px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #8d6747;
        }

        .footer {
            text-align: center;
            margin-top: 20px;
            font-size: 0.9rem;
            color: #93785c;
        }

        .ornament {
            text-align: center;
            margin: 20px 0;
            font-size: 1.5rem;
            color: #93785c;
        }
    </style>
    <title>한국 역사 문답</title>
</head>
<body>
<div class="scroll">
    <div class="header">
        <h1>한국 역사 문답</h1>
        <p class="subtitle">역사에 관한 질문을 올리시오</p>
    </div>

    <div class="main-content">
        <div class="scholar-image"></div>

        <div class="chat-area">
            <form id="questionForm">
                <textarea id="question" rows="4" placeholder="한국 역사에 관한 질문을 입력하십시오."></textarea>
                <center><button id="search-input" type="submit">문답 청하기</button></center>
            </form>
            <div class="answer-scroll" id="answer">
                <p>이곳에 역사 문답이 표시됩니다.</p>
            </div>
        </div>
    </div>

    <div class="ornament">※ ※ ※</div>

    <div class="footer">
        <p>조선왕조 역사 문답소 · 경복궁 내 · 한성부</p>
    </div>
</div>

<script>
    // 폼 제출 이벤트 처리
    document.getElementById('questionForm').addEventListener('submit', function(event) {
        event.preventDefault(); // 기본 폼 제출 방지
        askQuestion();
    });

    // 질문 처리 함수
    async function askQuestion() {
        let question = document.getElementById('question').value;
        let answerDiv = document.getElementById('answer');
        let button = document.querySelector("button");

        if (question.trim() === '') {
            alert('질문을 입력하십시오.');
            return;
        }

        // 버튼 비활성화 (중복 요청 방지)
        button.disabled = true;
        button.innerText = "문답을 요청 중...";
        answerDiv.innerHTML = "<p>문답을 준비 중입니다...</p>";

        try {
            let response = await fetch('/api/test', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ question : question })
            });
            console.log("서버 요청 전송: ", question);

            let data = await response.json();
            console.log("서버 응답 데이터:", data); // 응답을 콘솔에 출력

            if (data && data.answer) {
                button.innerText = "문답 청하기";
                answerDiv.innerText =   data.answer;
                button.disabled = false;

            } else {
                answerDiv.innerText = "서버 응답에 오류가 있습니다.";
                button.innerText = "문답 청하기";
                button.disabled = false;
            }
        } catch (error) {
            console.error("오류 발생:", error);
            answerDiv.innerText = "문답을 가져오는 중 오류가 발생했습니다.";
            button.innerText = "문답 청하기";
            button.disabled = false;
        }

    }
</script>
</body>
</html>