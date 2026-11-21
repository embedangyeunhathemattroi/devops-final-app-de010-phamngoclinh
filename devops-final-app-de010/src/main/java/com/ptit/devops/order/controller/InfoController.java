package com.ptit.devops.order.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Map;

@RestController
public class InfoController {
    @Value("${APP_VERSION:local}") private String version;
    @Value("${STUDENT_NAME:Pham Ngoc Linh}") private String name;
    @Value("${STUDENT_ID:B24DTCN360}") private String studentId;
    @Value("${STUDENT_CLASS:K24CNTT4}") private String studentClass;

    @GetMapping("/api/info")
    public Map<String, String> info() {
        return Map.of("version", version, "studentName", name,
                "studentId", studentId, "studentClass", studentClass, "examCode", "010");
    }
}
