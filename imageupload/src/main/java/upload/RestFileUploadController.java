package upload;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import upload.model.Image;
import upload.storage.StorageService;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@RestController
public class RestFileUploadController {
    private final StorageService storageService;
    private final Logger logger = LoggerFactory.getLogger(RestFileUploadController.class);


    @Autowired
    public RestFileUploadController(StorageService service) {
        this.storageService = service;
    }


    @PostMapping("/files")
    public ResponseEntity<?> uploadFile(@RequestParam("file") MultipartFile uploadFile) {
        logger.debug("Single file upload");

        storageService.store(uploadFile);

        return new ResponseEntity("Successfully uploaded - " + uploadFile.getOriginalFilename(), new HttpHeaders(), HttpStatus.OK);
    }


    @GetMapping("/files")
    @ResponseBody
    public List<Image> allFiles() {
        return storageService.loadAll().map(
                path -> new Image("http://localhost:8080/files/"+path.getFileName().toString(), path.getFileName().toString()) )
                .collect(Collectors.toList());
    }

    @GetMapping("/files/{id}.{ext}")
    public ResponseEntity<?> getFile(@PathVariable("id") String id, @PathVariable("ext") String ext) throws IOException {
        String filename = id + "." + ext;
        Resource file = storageService.loadAsResource(filename);
        return ResponseEntity.ok().header(HttpHeaders.CONTENT_DISPOSITION,
                "attachment; filename=\"" + file.getFilename() + "\"").body(file);
    }
}
