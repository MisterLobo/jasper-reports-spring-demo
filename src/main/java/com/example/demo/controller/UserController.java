package com.example.demo.controller;

import com.example.demo.entity.User;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.UserService;
import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("api")
public class UserController {

    final Logger log = LoggerFactory.getLogger((this.getClass()));
    final ModelAndView model = new ModelAndView();

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserService userService;

    @GetMapping(value = "/welcome")
    public ModelAndView index() {
        log.info("Showing the welcome page");
        model.setViewName("welcome");
        return model;
    }

    @GetMapping(value = "/pagination")
    public ModelAndView pagination() {
        log.info("Showing the pagination page");
        model.setViewName("pagination");
        return model;
    }

    @GetMapping(value = "/export")
    public ModelAndView export() {
        log.info("Showing the export page");
        model.setViewName("export");
        return model;
    }

    @GetMapping(value = "/basic-embed")
    public ModelAndView basicEmbed() {
        log.info("Showing the basic-embed page");
        model.setViewName("basic-embed");
        return model;
    }

    @GetMapping(value = "/view")
    public void viewReport(HttpServletResponse response) {
        log.info("preparing the pdf report view jasper.");
        try {
            final JasperPrint jasperPrint = createPdfReport(userService.report());
            JasperExportManager.exportReportToPdfStream(jasperPrint, response.getOutputStream());
            response.setContentType("application/pdf");
            response.addHeader("Content-Disposition", "inline; filename=report.pdf;");
        } catch (final Exception e) {
            log.error("Some error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private JasperPrint createPdfReport(final List<User> users) throws JRException, FileNotFoundException {
        log.info(this.getClass().getResource("/Cherry.jrxml").getPath());
        final String filePath = "reports/";
        final File file = ResourceUtils.getFile("classpath:Cherry.jrxml");
        log.info(file.getParent());
        log.info(file.getPath());
        final JRBeanCollectionDataSource dataSource = new JRBeanCollectionDataSource(users);
        //JasperCompileManager.compileReportToFile(src, dest);
        final JasperReport jasperReport = JasperCompileManager.compileReport(file.getAbsolutePath());
        final Map<String, Object> parameters = new HashMap<>();
        parameters.put("createdBy", "algae");
        final JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, dataSource);
        return jasperPrint;
    }


    // get all users
    @GetMapping("/users")
    public List<User> getAllUsers(HttpServletResponse response) {
        return userRepository.findAll();
    }

    // get user by id
    @GetMapping("/users/{id}")
    public User getUserById(@PathVariable (value = "id") long userId) {
        return this.userRepository.findById(userId).orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));
    }

    // create user
    @PostMapping("/users")
    public User createUser(@RequestBody User user) {
        return this.userRepository.save(user);
    }

    // update user
    @PutMapping("/users/{id}")
    public User updateUser(@RequestBody User user, @PathVariable ("id") long userId) {
        User existing = this.userRepository.findById(userId).orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));
        existing.setFirstName(user.getFirstName());
        existing.setLastName(user.getLastName());
        existing.setEmail(user.getEmail());
        return this.userRepository.save(existing);
    }

    // delete user
    @DeleteMapping("/users/{id}")
    public ResponseEntity<User> deleteUser(@PathVariable ("id") long userId) {
        User existing = this.userRepository.findById(userId).orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));
        this.userRepository.delete(existing);
        return ResponseEntity.ok().build();
    }

}
