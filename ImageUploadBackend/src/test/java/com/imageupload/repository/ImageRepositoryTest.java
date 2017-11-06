package com.imageupload.repository;

import com.imageupload.AbstractTest;
import com.imageupload.model.Image;
import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import java.util.ArrayList;

public class ImageRepositoryTest extends AbstractTest {

    @Autowired
    private ImageRepository imageRepository;

    @Before
    public void setup() {

    }

    @After
    public void tearDown() {

    }

    @Test
    public void testFindAll() {
        ArrayList<Image> images = new ArrayList<Image>();
        imageRepository.findAll().forEach(img-> images.add(img));

        Assert.assertNotNull(images);
        Assert.assertEquals(2, images.size());
    }

}
