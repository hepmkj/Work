package com.manoj;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class StartApplication {

  @GetMapping("favicon.ico")
  @ResponseBody
  void returnNoFavicon() {
  }

  @GetMapping("/test")
  @ResponseBody
  public ResponseEntity<String> tetsIt() {
    return new ResponseEntity<>("testing: /test", HttpStatus.OK);
  }

  public static void main(String[] args) {
    SpringApplication.run(StartApplication.class, args);
  }

}
