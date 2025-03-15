import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;


@WebServlet("/api/test")
public class GeminiController extends HttpServlet {
    private final GeminiService geminiService = new GeminiService();
    private final ObjectMapper objectMapper = new ObjectMapper(); // ObjectMapper 인스턴스 생성

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {

        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 요청 본문(JSON) 읽기
        BufferedReader reader = request.getReader();
        GeminiServiceRequest serviceRequest = objectMapper.readValue(reader, GeminiServiceRequest.class);

        // 질문에 대한 응답 가져오기
        String answer = geminiService.answerQuestion(serviceRequest.question());
        if (answer != null) {
            // JSON 응답 생성
            String jsonResponse = objectMapper.writeValueAsString(new GeminiServiceResponse(answer));
            response.getWriter().write(jsonResponse);

            System.out.println(jsonResponse+"체크");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

    }
}
