package com.imageupload.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@RestController
public class DocsController {
    @RequestMapping("/")
    public ModelAndView getDocs() {
        return new ModelAndView("redirect:/swagger-ui.html");
    }

    @RequestMapping("/docs")
    public ModelAndView getDocs2() {
        return new ModelAndView("redirect:/swagger-ui.html");
    }
}
