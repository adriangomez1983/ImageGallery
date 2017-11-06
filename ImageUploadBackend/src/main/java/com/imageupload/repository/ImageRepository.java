package com.imageupload.repository;

import com.imageupload.model.Image;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Repository
@Transactional
public interface ImageRepository extends CrudRepository<Image, UUID> {
}
