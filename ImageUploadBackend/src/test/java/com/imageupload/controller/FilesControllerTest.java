package com.imageupload.controller;

import com.imageupload.AbstractControllerTest;
import com.imageupload.repository.ImageRepository;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.transaction.annotation.Transactional;

@Transactional
public class FilesControllerTest extends AbstractControllerTest {

    @Autowired
    ImageRepository imageRepository;

    @Before
    public void setup() {
        super.setUp();
    }

    @Test
    public void testGetAllFiles() throws Exception {
        String uri = "/files/";

        MvcResult result = mvc.perform(
                MockMvcRequestBuilders.get(uri).accept(MediaType.APPLICATION_JSON)).andReturn();
        String content = result.getResponse().getContentAsString();
        int status = result.getResponse().getStatus();
        Assert.assertEquals("", 200, status);
        Assert.assertTrue("", content.trim().length() > 0);
    }
}
