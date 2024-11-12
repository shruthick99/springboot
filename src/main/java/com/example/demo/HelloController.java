package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {  // Class name should match the file name

    // Map to root URL ("/") instead of "/hello"
    @GetMapping("/")
    public String sayHello() {
        return "Hello, Miracle 12346677!";
    }
}
