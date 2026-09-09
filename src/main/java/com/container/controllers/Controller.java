package com.container.controllers;


import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;


    @RestController
    @RequestMapping("/api")
    public class Controller {

        @Value("${user.name}")
        private String USER_NAME ;

        @GetMapping("/health")
        public ResponseEntity<String> getHealth(){
            return ResponseEntity.ok("Hello ==> " + this.USER_NAME);
        }
    }
