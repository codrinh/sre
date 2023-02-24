package com.example.restservice;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@RestController
public class DemoController {

	// assign variable value from application.config/yaml
	// refactor: value structure
	@Value("${dummy.go.service}")
	private String dummy_go_service;

	private static final Logger logger = LoggerFactory.getLogger(DemoController.class);

	// refactor, function should be part of class not in the controller 
	private ResponseEntity<byte[]> callPdfApi() {
		RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<byte[]> result = null;
		try {
			result = restTemplate.exchange(dummy_go_service, HttpMethod.GET, null, byte[].class);
		} catch (Exception ex) {
			logger.error(ex.getMessage());
		}
		return result;
	}

	@GetMapping(value = "/{id:^[0-9]+}") // only int
	public ResponseEntity<Resource> getId(@PathVariable String id) {
		ResponseEntity<Resource> response;
		// refactor, logic should be moved into a function, different class 
		try {
			ResponseEntity<byte[]> pdfApiResult = callPdfApi();

			HttpHeaders respHeaders = new HttpHeaders();
			respHeaders.setContentType(pdfApiResult.getHeaders().getContentType()); // implement mime type analyzer https://tika.apache.org/
			respHeaders.setContentLength(pdfApiResult.getBody().length); // Potential null pointer access: The method getBody() may return null
			respHeaders.setContentDispositionFormData("attachment", 
					"dummy_file." + pdfApiResult.getHeaders().getContentType().getSubtype()); // Potential null pointer access: The method getContentType() may return null
			
			response = new ResponseEntity<Resource>(
				new ByteArrayResource(pdfApiResult.getBody()), respHeaders, HttpStatus.OK);
		} catch (Exception ex) {
			response = new ResponseEntity<Resource>(HttpStatus.BAD_GATEWAY);
			logger.error("Could not get a valid response from the PDF API: " + ex.getMessage());
		}
		return response;
	}
}
