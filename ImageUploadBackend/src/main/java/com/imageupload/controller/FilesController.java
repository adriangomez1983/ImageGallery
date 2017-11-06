package com.imageupload.controller;

import com.imageupload.model.Image;
import com.imageupload.repository.ImageRepository;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import org.apache.tomcat.util.http.fileupload.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import sun.nio.ch.IOUtil;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.UUID;

@RestController
@RequestMapping(path = "/files/")
@Api(value = "FilesControllerAPI", produces = MediaType.APPLICATION_JSON_VALUE)
public class FilesController {

    private ImageRepository imageRepository;

    @Autowired
    public void setImageRepository(ImageRepository imageRepository) {
        this.imageRepository = imageRepository;
    }

    @RequestMapping(method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ApiOperation("Gets all the uploaded files")
    @ApiResponses(value = {@ApiResponse(code = 200, message = "OK", response = Image.class)})
    public ResponseEntity<Collection<Image>> getAllFiles() {
        ArrayList<Image> result = new ArrayList<Image>();
        imageRepository.findAll().forEach(img -> result.add(img));

        return new ResponseEntity<Collection<Image>>(result,HttpStatus.OK);
    }

    @RequestMapping(path = "{id}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ApiOperation("Get a single image matching a given ID")
    @ApiResponses(value = {@ApiResponse(code = 200, message = "OK", response = Image.class)})
    public ResponseEntity<Image> getImage(@PathVariable(value = "id") UUID id) {
        Image image = imageRepository.findOne(id);
        if (image == null) {
            return new ResponseEntity<Image>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<Image>(image, HttpStatus.OK);
    }

    @RequestMapping(path = "{id}", method = RequestMethod.PUT, consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @ApiOperation("Updates a single image metadata")
    @ApiResponses(value = { @ApiResponse(code = 200, message = "OK", response = Image.class)})
    public ResponseEntity<Image> updateImage(@PathVariable(value = "id") UUID id, @RequestBody Image image) {
        Image img = getImage(id).getBody();
        if (img == null) {
            return new ResponseEntity<Image>(HttpStatus.NOT_FOUND);
        }
        Image updatedImage = imageRepository.save(image);
        return new ResponseEntity<Image>(updatedImage, HttpStatus.OK);
    }

    @RequestMapping(path = "{id}", method = RequestMethod.DELETE)
    @ApiOperation("Deletes a single image matching the given ID")
    @ApiResponses(value = { @ApiResponse(code = 200, message = "OK")})
    public ResponseEntity<Boolean> deleteImage(@PathVariable(value = "id") UUID id) {
        Image img = getImage(id).getBody();
        if (img == null) {
            return new ResponseEntity<Boolean>(HttpStatus.NOT_FOUND);
        }
        try {
            imageRepository.delete(id);
        } catch(IllegalArgumentException ex) {
            return new ResponseEntity<Boolean>(false, HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity(true, HttpStatus.OK);

    }

    @RequestMapping(path = "", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ApiOperation(value = "Creates a new image")
    @ApiResponses(value = { @ApiResponse(code = 201, message = "Created", response = Image.class)})
    public ResponseEntity<Image> uploadFile(@RequestParam(value = "file", required = true) MultipartFile uploadFile) {
        UUID newImageId = UUID.randomUUID();
        Image imageToBeSaved = new Image();
        imageToBeSaved.setId(newImageId);
        try {
            imageToBeSaved.setData(uploadFile.getBytes());
        } catch (IOException ex) {
            return new ResponseEntity<Image>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
        imageToBeSaved.setDisplayName(uploadFile.getOriginalFilename());
        imageToBeSaved.setUrl("http://localhost:8080/files/image-data/"+newImageId.toString());
        Image savedImage = imageRepository.save(imageToBeSaved);

        return new ResponseEntity(savedImage, HttpStatus.OK);
    }

    @RequestMapping(path = "image-data/{id}", method = RequestMethod.GET)
    @ApiOperation("Gets image binary data of on image matching the given ID")
    @ApiResponses(value = { @ApiResponse(code = 200, message = "OK")})
    public void getImageData(@PathVariable(value = "id") UUID id, HttpServletResponse response) {
        Image img = imageRepository.findOne(id);
        if (img == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        }
        response.setStatus(HttpServletResponse.SC_OK);
        response.addHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + img.getDisplayName() + "\"");
        response.setContentType("image/png");
        ByteArrayInputStream is = new ByteArrayInputStream(img.getData());
        try {
            copy(is, response.getOutputStream());
            response.getOutputStream().flush();
        } catch (IOException ex) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }


    }

    private void copy(ByteArrayInputStream is, ServletOutputStream os) throws IOException {
        byte[] buffer = new byte[1024];
        int len;
        while ((len = is.read(buffer)) != -1) {
            os.write(buffer, 0, len);
        }
    }

}
