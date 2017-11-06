package com.imageupload;

import com.imageupload.model.Image;
import com.imageupload.repository.ImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

import java.util.UUID;
import java.util.logging.Logger;

@Component
public class ImageLoader implements ApplicationListener<ContextRefreshedEvent> {

    private ImageRepository imageRepository;
    private Logger log = Logger.getLogger(ImageLoader.class.getName());


    @Autowired
    public void setImageRepository(ImageRepository imageRepository) {
        this.imageRepository = imageRepository;
    }

    @Override
    public void onApplicationEvent(ContextRefreshedEvent event) {
//        UUID id1 = UUID.randomUUID();
//        Image testImage = new Image();
//        testImage.setId(id1);
//        testImage.setUrl("http://localhost/files/someUUID.png");
//        testImage.setDisplayName("some_test_image");
//        testImage.setData("0xe04fd020ea3a6910a2d808002b30309d".getBytes());
//        imageRepository.save(testImage);
//        log.info("Image saved - uuid: "+testImage.getId());
//
//        UUID id2 = UUID.randomUUID();
//        Image testImage2 = new Image();
//        testImage.setId(id2);
//        testImage.setUrl("http://localhost/files/someUUID2.png");
//        testImage.setDisplayName("some_test_image2");
//        testImage.setData("0xe04fd020ea3a6910a2d808002b303444".getBytes());
//        imageRepository.save(testImage2);
//        log.info("Image saved - uuid: "+testImage2.getId());
//
//        log.info("Retrieving images");
//        imageRepository.findAll().forEach( img -> log.info("IMG: " + img));
    }


}
